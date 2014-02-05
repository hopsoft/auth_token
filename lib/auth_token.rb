require "yaml/store"
require_relative "auth_token/token"
require_relative "auth_token/version"

module AuthToken

  class << self

    attr_reader :file_path

    def set_file_path(value)
      @file_path = value
    end

    def file
      @file ||= begin
        raise "file_path not set" if file_path.nil?
        YAML::Store.new(file_path, true)
      end
    end

    def exists?(key)
      !!(file.transaction { file[key.to_s] })
    end

    def find(key)
      exists?(key) ? AuthToken::Token.new(key) : nil
    end

    def delete(key)
      file.transaction { file.delete(key.to_s) }
    end

  end

end

