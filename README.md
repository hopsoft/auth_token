# A simple api-key storage engine

[![Build Status](https://travis-ci.org/hopsoft/key_store.png?branch=master)](https://travis-ci.org/hopsoft/key_store)
[![Dependency Status](https://gemnasium.com/hopsoft/key_store.png)](https://gemnasium.com/hopsoft/key_store)
[![Code Climate](https://codeclimate.com/github/hopsoft/key_store.png)](https://codeclimate.com/github/hopsoft/key_store)

Easily create & store api-keys to help secure your API.

* Simple
* Does 1 thing well
* Accepts custom key values
* Works with any framework
* Human friendly storage

*KeyStore leverages a threadsafe [YAML::Store](http://ruby-doc.org/stdlib-2.1.0/libdoc/yaml/rdoc/YAML/Store.html)
backend for simple api-key management.*

**Note:** Best for smaller projects.
You should look elsewhere if you're managing more than a few hundred api-keys.

## Usage

### Install

```sh
gem install key_store
```

### Configure the storage location

```ruby
require "key_store"
KeyStore.set_file_path "/path/to/keys.yml"
```

### Create an api-key

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e")
# note: the key name can be any custom string value
```

### Save an api-key

```ruby
key = KeyStore::key.new("2de1c1c7aefee1f811a20dfdfa30597e")
key.save!
```

### Delete an api-key

```ruby
KeyStore.delete!("2de1c1c7aefee1f811a20dfdfa30597e")
```

### See if an api-key exists

```ruby
KeyStore.exists?("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Find an api-key

```ruby
key = KeyStore.find("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Save an api-key with roles

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e", roles: ["read", "write"])
key.roles << "admin"
key.save!
# note: roles are arbitrary... define as many as your app needs
```

### Save an api-key with notes

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e",
  roles: ["read", "write"],
  notes: "This key is for testing only."
)
key.notes += " One more thing..."
key.save!
```

### Inspect an api-key's name

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e")
key.name # => "2de1c1c7aefee1f811a20dfdfa30597e"
```

### Inspect an api-key's HTTP header

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e")
key.http_header # => "Authorization: Token token=\"2de1c1c7aefee1f811a20dfdfa30597e\""
```

### Inspect an api-key's roles

```ruby
key = KeyStore::Key.new("2de1c1c7aefee1f811a20dfdfa30597e", roles: ["read", "write"])
key.roles # => ["read", "write"]
```

### Review the YAML file

Keys are stored in a human friendly YAML file and can be manually edited.

*The location of this file is configurable. [See above](#configure-the-storage-location)*

```yaml
# /path/to/keys.yml
---
2de1c1c7aefee1f811a20dfdfa30597e:
  :roles:
  - read
  - write
  :notes: This key is for testing only. One more thing...
  :http_header: 'Authorization: Token token="2de1c1c7aefee1f811a20dfdfa30597e"'
```

## Example Rails Integration

First, ensure that any desired api-keys exist in the YAML file.
Then add the dependency to the Gemfile.

```ruby
# Gemfile
gem "key_store"
```

Next, use an initializer to configure the api-keys file location.

```ruby
# config/initializers/key_store.rb
KeyStore.set_file_path File.join(Rails.root, "db/keys.yml")

# optionally ensure a test api-key exists
if Rails.env == "development"
  test_key = KeyStore::Key.new("test-key",
    roles: [:test],
    notes: "This key is for testing only."
  )
  test_key.save!
end
```

Finally, add authentication to your controllers.

```ruby
#app/controller/users_controller.rb
require "key_store"

class UsersController < ActionController::Base

  before_filter :verify_key_store

  def show
    # logic here ...
  end

  protected

  def verify_key_store
    # note: consumers should pass the api-key in the "Authorization" HTTP header
    authenticate_or_request_with_http_token do |token, options|
      # use the @api_key with your favorite authorization library
      # cancan for example
      @api_key = KeyStore.find(token)
    end
  end

end
```

**Note**: This authentication strategy is basic & should be secured with [TLS/SSL](http://en.wikipedia.org/wiki/Transport_Layer_Security).

Learn more about the capabilities built into Rails that can be used to secure an API at
[Rails Casts](http://railscasts.com/episodes/352-securing-an-api?view=asciicast).

