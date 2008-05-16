# Submarine

Submarine is a rewrite of the DHH's AccountLocation plugin.  You can set the subdomain AR model and column instead of having to use the Account model.

It also has support for subdomains in a development environment, something AccountLocation lacked.

## Localhost Setup (OSX 10.5)

* Edit /etc/hosts by adding your aliases after the localhost (on the same line):

<pre>
127.0.0.1     localhost foo.localhost bar.localhost
</pre>

* Then clear the cached DNS entries:

<pre>
sudo dscacheutil -flushcache
</pre>

## Instructions

* Include Submarine in one of your controllers or just once in the application controller:

<pre>
class ApplicationController < ActionController::Base
   include Submarine
end
</pre>

* Submarine uses the User model and the 'login' attribute by default (restful_authentication).  To overwrite this, change the following options before including the module:

<pre>
class ApplicationController < ActionController::Base
   Submarine.subdomain_model = 'account'
   Submarine.subdomain_column = 'name'
   include Submarine
end
</pre>

## Examples

* When accessing either of these URL's http://foo.localhost:3000 or http://foo.domain.com

<pre>

@user = User.create(:login => 'foo')   
   
user_subdomain
=> 'foo'

user_url
in development => 'http://foo.localhost:3000'
in production => 'http://foo.domain.com'

user_url('bar')
in development => 'http://bar.localhost:3000'
in production => 'http://bar.domain.com'
</pre>

* You can use the model_subdomain method in a before filter to use the subdomain as an account key

<pre>
class ProductsController < ApplicationController
   before_filter load_user
   
   def load_user
      @user = User.find_by_login(user_subdomain)
   end
end 
</pre>


---
Copyright (c) 2008 Norbauer Inc, released under the MIT license<br/>
Written by Jose Fernandez with support from The Sequoyah Group
