require "yaml/store"
require "thread"
require "fileutils"
require_relative "auth_token/token"
require_relative "auth_token/version"

module AuthToken

  class << self

    attr_reader :file_path

    def set_file_path(value)
      @file_path = value
    end

    def file
      if @file.nil? || modified?
        Mutex.new.synchronize do
          @file = begin
            raise "file_path not set" if file_path.nil?
            FileUtils.touch(file_path) unless File.exists?(file_path)
            self.mtime = File.mtime(file_path)
            YAML::Store.new(file_path, true)
          end
        end
      end
      @file
    end

    def exists?(key)
      !!(file.transaction { file[key.to_s] })
    end

    def find(key)
      exists?(key) ? AuthToken::Token.new(key) : nil
    end

    def delete!(key)
      file.transaction { file.delete(key.to_s) }
    end

    private

    attr_accessor :mtime

    def modified?
      return true if mtime.nil? || !File.exists?(file_path)
      File.mtime(file_path) != mtime
    end

  end

end

