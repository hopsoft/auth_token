require "forwardable"

module KeyStore
  class Key
    extend Forwardable

    def_delegators :KeyStore, :file, :exists?
    attr_reader :name, :roles
    attr_accessor :notes
    alias_method :to_s, :name

    def initialize(name, roles: nil, notes: nil)
      @name = name.to_s

      if exists?(name)
        set_roles_from_file if roles.nil?
        set_notes_from_file if notes.nil?
      end

      @roles ||= (roles || []).map(&:to_s)
      @notes ||= notes.to_s
    end

    def http_header
      "Authorization: Token token=\"#{name}\""
    end

    def save!
      file.transaction do
        file[name] ||= {}
        file[name][:roles] = roles.map(&:to_s)
        file[name][:notes] = notes.to_s
        file[name][:http_header] = http_header
      end
    end

    private

    def set_roles_from_file
      file.transaction do
        @roles = file[name][:roles]
      end
    end

    def set_notes_from_file
      file.transaction do
        @notes = file[name][:notes]
      end
    end

  end
end
