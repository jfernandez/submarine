require 'rubygems'
require 'spec'
require 'action_controller'
require 'action_controller/test_process'
require File.dirname(__FILE__) + '/../lib/submarine.rb'
 
Spec::Runner.configure do |config|
  config.mock_with :mocha
end

module Submarine
  class User
    def initialize(login)
      @@login = login
    end
    
    def login
      @@login
    end
  end
  
  class Blog
    def initialize(name)
      @@name = name
    end
    
    def name
      @@name
    end
  end
end