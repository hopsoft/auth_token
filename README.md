# A simple auth token storage engine

[![Build Status](https://travis-ci.org/hopsoft/auth_token.png?branch=master)](https://travis-ci.org/hopsoft/auth_token)
[![Dependency Status](https://gemnasium.com/hopsoft/auth_token.png)](https://gemnasium.com/hopsoft/auth_token)
[![Code Climate](https://codeclimate.com/github/hopsoft/auth_token.png)](https://codeclimate.com/github/hopsoft/auth_token)

Easily create & store auth tokens for any API.

* Simple
* Does 1 thing well
* Accepts custom token values
* Works with any framework
* Human friendly storage

*AuthToken leverages a threadsafe [YAML::Store](http://ruby-doc.org/stdlib-2.1.0/libdoc/yaml/rdoc/YAML/Store.html)
backend for simple token management.*

## Usage

### Install

```sh
gem install auth_token
```

### Configure the storage location

```ruby
require "auth_token"
AuthToken.set_file_path "/path/to/auth_tokens.yml"
```

### Create & save a token

```ruby
token = AuthToken::Token.new("2de1c1c7aefee1f811a20dfdfa30597e")
token.save!
# note: the token key can be any custom string value
```

### See if a token exists

```ruby
AuthToken.exists?("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Find a token

```ruby
token = AuthToken.find("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Delete a token

```ruby
AuthToken.delete!("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Save a token with roles

```ruby
key = "2de1c1c7aefee1f811a20dfdfa30597e"
token = AuthToken::Token.new(key, roles: ["read", "write"])
token.roles << "admin"
token.save!
# note: roles are arbitrary... define as many as your app needs
```

### Save a token with notes

```ruby
key = "2de1c1c7aefee1f811a20dfdfa30597e"
token = AuthToken::Token.new(key,
  roles: ["read", "write"],
  notes: "This token is for testing only."
)
token.notes += " One more thing..."
token.save!
```

### Review the YAML file

Tokens are stored in a human friendly YAML file and can be manually edited.

*The location of this file is configurable. [See above](#configure-the-storage-location)*

```yaml
# /path/to/auth_tokens.yml
---
2de1c1c7aefee1f811a20dfdfa30597e:
  :roles:
  - read
  - write
  :notes: This token is for testing only. One more thing...
  :http_header: 'Authorization: Token token="2de1c1c7aefee1f811a20dfdfa30597e"'
```

## Example Rails Integration

First, ensure that any desired tokens exist in the YAML file.
Then add the dependency to the Gemfile.

```ruby
# Gemfile
gem "auth_token"
```

Next, use an initializer to configure the token file location.

```ruby
# config/initializers/auth_token.rb
AuthToken.set_file_path File.join(Rails.root, "db/auth_tokens.yml")

# optionally ensure a test token exists
if Rails.env == "development"
  test_token = AuthToken::Token.new("test-token",
    roles: [:test],
    notes: "This token is for testing only."
  )
  test_token.save!
end
```

Finally, add authentication to your controllers.

```ruby
#app/controller/users_controller.rb
require "auth_token"

class UsersController < ActionController::Base

  before_filter :verify_auth_token

  def show
    # logic here ...
  end

  protected

  def verify_auth_token
    # note: consumers should pass the token in the "Authorization" HTTP header
    authenticate_or_request_with_http_token do |token, options|
      # use the @auth_token with your favorite authorization library
      # cancan for example
      @auth_token = AuthToken.find(token)
    end
  end

end
```

Learn more about the capabilities built into Rails that can be used to secure an API at
[Rails Casts](http://railscasts.com/episodes/352-securing-an-api?view=asciicast).

