module Submarine
  mattr_accessor :subdomain_model
  mattr_accessor :subdomain_column
  
  def self.included(controller)
    @@subdomain_model ||= 'user'
    @@subdomain_column ||= 'login'
    
    controller.helper_method(:current_subdomain)
  end
  
  protected
  
    def default_subdomain
      instance.send(Submarine.subdomain_column) if instance && instance.respond_to?(Submarine.subdomain_column)
    end
  
    def current_subdomain
      request.host.include?('localhost') ? request.subdomains(0).first : request.subdomains.first
    end
  
  private
    def instance
      instance_variable_get "@#{Submarine.subdomain_model}"
    end
end 