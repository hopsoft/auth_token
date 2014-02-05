# A simple auth token storage engine

Easily create & store auth tokens for any API.

* Simple
* Does 1 thing well
* Accepts custom token values
* Works with any framework
* Human friendly storage

*AuthToken leverages a threadsafe [YAML::Store](http://ruby-doc.org/stdlib-2.1.0/libdoc/yaml/rdoc/YAML/Store.html)
backend for simple token management.*

## Basic Usage

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

### Find a token

```ruby
token = AuthToken.find("2de1c1c7aefee1f811a20dfdfa30597e")
```

### Save a token with roles

```ruby
key = "2de1c1c7aefee1f811a20dfdfa30597e"
token = AuthToken::Token.new(key, roles: ["read", "write"])
token.roles << "delete"
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

### Review the tokens file

Tokens are stored in a human friendly YAML file and can be manually edited.

*The location of this file is configurable. See above.*

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

## Using with Rails

First, ensure that any desired tokens exist in the YAML file.
Then add the dependency to the Gemfile.

```ruby
# Gemfile
gem "auth_token"
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

  private

  def verify_auth_token
    # note: consumers should pass the token in the "Authorization" HTTP header
    authenticate_or_request_with_http_token do |token, options|
      AuthToken.find(token)
    end
  end

end
```

