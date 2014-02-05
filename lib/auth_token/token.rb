require "forwardable"

module AuthToken
  class Token
    extend Forwardable

    def_delegators :AuthToken, :file, :exists?
    attr_reader :key, :roles
    attr_accessor :notes
    alias_method :to_s, :key

    def initialize(key, roles: nil, notes: nil)
      @key = key.to_s

      if exists?(key)
        set_roles_from_file if roles.nil?
        set_notes_from_file if notes.nil?
      end

      @roles ||= (roles || []).map(&:to_s)
      @notes ||= notes.to_s
    end

    def http_header
      "Authorization: Token token=\"#{key}\""
    end

    def save!
      file.transaction do
        file[key] ||= {}
        file[key][:roles] = roles.map(&:to_s)
        file[key][:notes] = notes.to_s
        file[key][:http_header] = http_header
      end
    end

    private

    def set_roles_from_file
      file.transaction do
        @roles = file[key][:roles]
      end
    end

    def set_notes_from_file
      file.transaction do
        @notes = file[key][:notes]
      end
    end

  end
end
