require "yaml/store"
require "thread"
require "fileutils"
require_relative "key_store/key"
require_relative "key_store/version"

module KeyStore

  class << self

    attr_reader :file_path

    def set_file_path(value)
      @file_path = value
    end

    def store
      if @store.nil? || modified?
        Mutex.new.synchronize do
          @store = begin
            raise "file_path not set" if file_path.nil?
            FileUtils.touch(file_path) unless File.exists?(file_path)
            self.mtime = File.mtime(file_path)
            YAML::Store.new(file_path, true)
          end
        end
      end
      @store
    end

    def exists?(name)
      !!(store.transaction { |f| f.root?(name.to_s) })
    end

    def find(name)
      exists?(name) ? KeyStore::Key.new(name) : nil
    end

    def delete!(name)
      store.transaction { |f| f.delete(name.to_s) }
    end

    def to_hash
      YAML.load(File.read(file_path))
    end

    private

    attr_accessor :mtime

    def modified?
      return true if mtime.nil? || !File.exists?(file_path)
      File.mtime(file_path) != mtime
    end

  end

end

