# Submarine

Submarine was built upon DHH's [Account Location](http://dev.rubyonrails.org/svn/rails/plugins/account_location/) plugin.  It gives you a set of protected methods that use the subdomain as a way of identifying the current scope. These methods allow you to easily produce URLs that match this style and to get the current subdomain from a request. Submarine includes support for subdomains in a development environment running on localhost.  

## Localhost Setup (OSX 10.5)

* Edit /etc/hosts by adding your aliases after the localhost (on the same line):

<pre>
127.0.0.1     localhost foo.localhost bar.localhost
</pre>

* Then you must clear the cached DNS entries:

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

* Submarine will generate the following helper methods (using the default settings): `user_url, user_host, user_domain`.  It will also provide you a method to retrieve the current request's subdomain: `current_subdomain`

* By default, all helper methods will query @user.login (hi restufl_authentication) when generating the subdomain part.  You can set these attributes by overwriting the `subdomain_model` and `subdomain_column` methods in your controller after including the module:

<pre>
class ApplicationController < ActionController::Base
   include Submarine
   
   def subdomain_model
      'account'
   end
   
   def subdomain_column
      'name'
   end
end
</pre>

* Doing so will grant you a new set of helper methods, prepending the `subdomain_model` instead of 'user' (using the example above): `account_url, account_host, account_domain`

* If you pass along a string as a parameter to the helper methods, these will use it for the subdomain part of the URL's.

<pre>
@account.name
=> 'quack'

account_url
=> 'http://quack.domain.com'

account_url('moo')
=> 'http://moo.domain.com'
</pre>

## Examples

You have a domain that hosts several blogs and you wish to shorten their URL from `http://www.domain.com/blogs/fooblog/posts` to `http://fooblog.domain.com/`

<pre>
def PostsController < ApplicationController
	include Submarine
	
	before_filter :load_blog
	
	def subdomain_model; 'blog' end
	def subdomain_column; 'name' end
	
	def index
		@posts = @blog.posts
	end
	
protected

	def load_blog
		@blog = Blog.find_by_name(current_subdomain)
	end
end
</pre>

If you want to link to each of your blogs when the users visit your domain, you can use the helper methods in your views

    <div class="sidebar">
        <ul>
        <% @blogs.each do |blog| %>
			<li><%= blog_url(blog.name) %></li>
		<% end %>
        </ul>
    </div>

## TODO

* <strike>Use `method_missing` instead of method_alias for the model name based helpers.</strike>
* Helper method tests
* Add subdomain based routing support

---
Copyright (c) 2008 Norbauer Inc, released under the MIT license<br/>
Written by Jose Fernandez with support from Norbauer Inc.

