require File.dirname(__FILE__) + '/../spec_helper'
require 'spec'

module Submarine
  class UsersController < ActionController::Base
    include Submarine
    public :current_subdomain, :default_submarine_subdomain
    
    def index() render :nothing => true end
    alias_method :show, :index
    def rescue_action(e) raise end
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

describe Submarine::UsersController, :type => :controller do
  controller_name :users_controller
  
  it "should respond to #current_subdomain" do
    get 'index'
  end
end