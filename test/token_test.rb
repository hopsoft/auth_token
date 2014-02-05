require_relative "test_helper"

class TokenTest < MicroTest::Test

  before do
    @file_path = File.expand_path("../auth-tokens.yml", __FILE__)
    AuthToken.set_file_path @file_path
    AuthToken.delete(:foobar)
  end

  test "key set on initialize" do
    token = AuthToken::Token.new(:foobar)
    assert token.key == "foobar"
  end

  test "initialize doesn't save token" do
    assert AuthToken.exists?(:foobar) == false
    AuthToken::Token.new(:foobar)
    assert AuthToken.exists?(:foobar) == false
  end

  test "initialize with roles" do
    roles = [:foo, :bar, :baz]
    token = AuthToken::Token.new(:foobar, roles: roles)
    assert token.roles == roles.map(&:to_s)
  end

  test "initialize with notes" do
    notes = "There are notes."
    token = AuthToken::Token.new(:foobar, notes: notes)
    assert token.notes == notes
  end

  test "http_header after initialize" do
    token = AuthToken::Token.new(:foobar)
    assert token.http_header == "Authorization: Token token=\"foobar\""
  end

  test "basic save" do
    token = AuthToken::Token.new(:foobar)
    token.save!
    assert AuthToken.exists?(:foobar)
  end

  test "save with roles" do
    roles = [:foo, :bar, :baz]
    token = AuthToken::Token.new(:foobar, roles: roles)
    token.save!
    token = AuthToken.find(:foobar)
    assert token.roles == roles.map(&:to_s)
  end

  test "save with notes" do
    notes = "There are notes."
    token = AuthToken::Token.new(:foobar, notes: notes)
    token.save!
    token = AuthToken.find(:foobar)
    assert token.notes == notes
  end

  test "append roles & multiple saves" do
    token = AuthToken::Token.new(:foobar, roles: [:foo])
    token.save!
    token = AuthToken.find(:foobar)
    token.roles << :bar
    token.roles << :baz
    token.save!
    token = AuthToken.find(:foobar)
    assert token.roles == [:foo, :bar, :baz].map(&:to_s)
  end

  test "update notes" do
    token = AuthToken::Token.new(:foobar, notes: "note 1")
    token.save!
    token = AuthToken.find(:foobar)
    assert token.notes == "note 1"
    token.notes = "note 2"
    token.save!
    token = AuthToken.find(:foobar)
    assert token.notes == "note 2"
  end

end

