require_relative "test_helper"

class AuthTokenTest < MicroTest::Test

  before do
    @file_path = File.expand_path("../auth-tokens.yml", __FILE__)
    AuthToken.set_file_path @file_path
    AuthToken.delete!(:foobar)
  end

  test "set_file_path" do
    assert AuthToken.file_path == @file_path
  end

  test "file errors with nil file_path" do
    AuthToken.instance_eval do
      @file_path = @file = nil
    end

    begin
      assert AuthToken.file
    rescue Exception => e
      error = e
    end

    assert !error.nil?
  end

  test "file success with valid file_path" do
    assert AuthToken.file
  end

  test "unknown key does not exist" do
    assert AuthToken.exists?(:foobar) == false
  end

  test "find returns nil on unknown key" do
    assert AuthToken.find(:foobar).nil?
  end

  test "ok to call delete! on unknown key" do
    assert AuthToken.delete!(:foobar).nil?
  end

end
