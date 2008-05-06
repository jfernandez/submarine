module Submarine
  
  mattr_writer :subdomain_model
  def self.subdomain_model
    @@subdomain_model ||= 'user'
  end
  
  mattr_writer :subdomain_column
  def self.subdomain_column
    @@subdomain_column ||= 'login'
  end
  
  def self.included(controller)
    controller.helper_method(:current_subdomain, :default_subdomain)
  end
    
protected

  def current_subdomain
    request.host.include?('localhost') ? request.subdomains(0).first : request.subdomains.first
  end
  
  def default_subdomain
    instance_variable_get("@#{Submarine.subdomain_model}").send(Submarine.subdomain_column) if instance_variable_get("@#{Submarine.subdomain_model}")
  end
  
end 