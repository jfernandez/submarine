# Include this file in your test by copying the following line to your test:
# require File.expand_path(File.dirname(__FILE__) + "/test_helper")

$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'action_controller'
require 'action_controller/test_process'
require 'submarine'

module ActionController
  class TestRequest
    def with_subdomain(subdomain=nil)
      the_host_name = "localhost.com"
      the_host_name = "#{subdomain}.localhost.com" if subdomain
      self.host = the_host_name
      self.env['SERVER_NAME'] = the_host_name
      self.env['HTTP_HOST'] = the_host_name
    end
  end
end