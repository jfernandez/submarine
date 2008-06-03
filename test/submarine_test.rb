require File.expand_path(File.dirname(__FILE__) + "/test_helper")

module Submarine
  class UsersController < ActionController::Base
    include Submarine
    public :current_subdomain, :default_submarine_subdomain
    
    def index() render :nothing => true end
    alias_method :show, :index
    def rescue_action(e) raise end
    def method_missing(method_id, *args); super end
  end
  
  class BlogsController < ActionController::Base
    include Submarine
    public :current_subdomain, :default_submarine_subdomain
    
    def subdomain_model; 'blog' end
    def subdomain_column; 'name' end
    def index() render :nothing => true end
    alias_method :show, :index
    def rescue_action(e) raise end
  end
end

class SubmarineTest < Test::Unit::TestCase
  
  def setup
    @controller = Submarine::UsersController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    ActionController::Routing::Routes.draw { |map| map.connect ':controller/:action/:id' }
  end
  
  def test_controller_method_missing_should_not_override_plugin_version
    @request.with_subdomain('foobar')
    get :index
    @controller.instance_variable_set(:@user, Submarine::User.new('foobar'))
    assert_nothing_raised { @controller.user_url }
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
  
  def test_controller_should_not_raise_any_errors_on_model_based_methods
    @request.with_subdomain('foobar')
    get :index
    @controller.instance_variable_set(:@user, Submarine::User.new('foobar'))
    assert_nothing_raised { @controller.user_url }
    assert_nothing_raised { @controller.user_domain }
    assert_nothing_raised { @controller.user_host }
  end
  
  def test_model_based_methods_should_return_the_correct_strings
    @request.with_subdomain('foobar')
    get :index
    @controller.instance_variable_set(:@user, Submarine::User.new('foobar'))
    assert_equal('http://foobar.localhost.com', @controller.user_url)
    assert_equal('localhost.com', @controller.user_domain)
    assert_equal('foobar.localhost.com', @controller.user_host)
  end
  
  def test_model_based_methods_should_return_the_correct_string_when_a_parameter_is_used
    @request.with_subdomain('foobar')
    get :index
    @controller.instance_variable_set(:@user, Submarine::User.new('foobar'))
    assert_equal('http://quack.localhost.com', @controller.user_url('quack'))
    assert_equal('quack.localhost.com', @controller.user_host('quack'))
  end
  
end