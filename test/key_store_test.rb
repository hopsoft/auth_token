require_relative "test_helper"

class KeyStoreTest < MicroTest::Test

  before do
    @file_path = File.expand_path("../keys.yml", __FILE__)
    KeyStore.set_file_path @file_path
    KeyStore.delete!(:foobar)
  end

  test "set_file_path" do
    assert KeyStore.file_path == @file_path
  end

  test "file errors with nil file_path" do
    KeyStore.instance_eval do
      @file_path = @file = nil
    end

    begin
      assert KeyStore.file
    rescue Exception => e
      error = e
    end

    assert !error.nil?
  end

  test "file success with valid file_path" do
    assert KeyStore.file
  end

  test "unknown key does not exist" do
    assert KeyStore.exists?(:foobar) == false
  end

  test "find returns nil on unknown key" do
    assert KeyStore.find(:foobar).nil?
  end

  test "ok to call delete! on unknown key" do
    assert KeyStore.delete!(:foobar).nil?
  end

end
