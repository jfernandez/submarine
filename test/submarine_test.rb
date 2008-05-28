require File.expand_path(File.dirname(__FILE__) + "/test_helper")

module Submarine
  class UsersController < ActionController::Base
    include Submarine
    public :current_subdomain, :default_submarine_subdomain
  
    def index() render :nothing => true end
    alias_method :show, :index
    def rescue_action(e) raise end
  end

  class User
    def initialize(login)
      @@login = login
    end
    
    def login
      @@login
    end
  end
end

class SubmarineTest < Test::Unit::TestCase
  
  def setup
    @controller = Submarine::UsersController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action/:id' }
  end
  
  def test_controller_should_respond_to_current_subdomain_method
    assert @controller.respond_to?(:current_subdomain)
  end
  
  def test_current_subdomain_method
    @request.with_subdomain('foobar')
    get :index
    assert_equal('foobar', @controller.current_subdomain)
  end
  
  def test_should_return_default_submarine_subdomain
    @controller.instance_variable_set(:@user, Submarine::User.new('foobar'))
    assert_equal('foobar', @controller.default_submarine_subdomain)
  end
  
end