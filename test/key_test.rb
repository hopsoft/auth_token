require_relative "test_helper"

class KeyTest < MicroTest::Test

  before do
    @file_path = File.expand_path("../keys.yml", __FILE__)
    KeyStore.set_file_path @file_path
    KeyStore.delete!(:foobar)
  end

  test "name set on initialize" do
    key = KeyStore::Key.new(:foobar)
    assert key.name == "foobar"
  end

  test "initialize doesn't save key" do
    assert KeyStore.exists?(:foobar) == false
    KeyStore::Key.new(:foobar)
    assert KeyStore.exists?(:foobar) == false
  end

  test "initialize with roles" do
    roles = [:foo, :bar, :baz]
    key = KeyStore::Key.new(:foobar, roles: roles)
    assert key.roles == roles.map(&:to_s)
  end

  test "initialize with notes" do
    notes = "There are notes."
    key = KeyStore::Key.new(:foobar, notes: notes)
    assert key.notes == notes
  end

  test "http_header after initialize" do
    key = KeyStore::Key.new(:foobar)
    assert key.http_header == "Authorization: Token token=\"foobar\""
  end

  test "basic save" do
    key = KeyStore::Key.new(:foobar)
    key.save!
    assert KeyStore.exists?(:foobar)
  end

  test "save with roles" do
    roles = [:foo, :bar, :baz]
    key = KeyStore::Key.new(:foobar, roles: roles)
    key.save!
    key = KeyStore.find(:foobar)
    assert key.roles == roles.map(&:to_s)
  end

  test "save with notes" do
    notes = "There are notes."
    key = KeyStore::Key.new(:foobar, notes: notes)
    key.save!
    key = KeyStore.find(:foobar)
    assert key.notes == notes
  end

  test "append roles & multiple saves" do
    key = KeyStore::Key.new(:foobar, roles: [:foo])
    key.save!
    key = KeyStore.find(:foobar)
    key.roles << :bar
    key.roles << :baz
    key.save!
    key = KeyStore.find(:foobar)
    assert key.roles == [:foo, :bar, :baz].map(&:to_s)
  end

  test "update notes" do
    key = KeyStore::Key.new(:foobar, notes: "note 1")
    key.save!
    key = KeyStore.find(:foobar)
    assert key.notes == "note 1"
    key.notes = "note 2"
    key.save!
    key = KeyStore.find(:foobar)
    assert key.notes == "note 2"
  end

end

