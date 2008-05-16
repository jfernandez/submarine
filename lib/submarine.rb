module Submarine
  
  class SubdomainModelError < NoMethodError; end
  class SubdomainColumnError < NoMethodError; end
  
  mattr_accessor :subdomain_model
  mattr_accessor :subdomain_column
  
  def self.included(controller)
    @@subdomain_model ||= 'user'
    @@subdomain_column ||= 'login'
    
    alias_method "#{@@subdomain_model}_domain", :submarine_domain
    #alias_method "#{@@subdomain_model}_subdomain", :submarine_subdomain
    alias_method "#{@@subdomain_model}_host", :submarine_host
    alias_method "#{@@subdomain_model}_url", :submarine_url
    controller.helper_method("#{@@subdomain_model}_domain", "current_subdomain", "#{@@subdomain_model}_host", "#{@@subdomain_model}_url")
  end
  
  protected
  
    def default_submarine_subdomain
      raise SubdomainModelError.new("@#{Submarine.subdomain_model} instance variable not found") if instance.nil?
      raise SubdomainColumnError.new("@#{Submarine.subdomain_model} does not have a '#{Submarine.subdomain_column}' attribute") unless instance.respond_to?(Submarine.subdomain_column)
      instance.send(Submarine.subdomain_column)
    end
    
    def submarine_url(submarine_subdomain = default_submarine_subdomain, use_ssl = request.ssl?)
      (use_ssl ? "https://" : "http://") + submarine_host(submarine_subdomain)
    end
    
    def submarine_host(submarine_subdomain = default_submarine_subdomain)
      submarine_host = ""
      submarine_host << submarine_subdomain + "."
      submarine_host << submarine_domain
    end
    
    def submarine_domain
      submarine_domain = ""
      submarine_domain << request.subdomains[1..-1].join(".") + "." if request.subdomains.size > 1
      submarine_domain << request.domain + request.port_string
    end
  
    def current_subdomain
      request.host.include?('localhost') ? request.subdomains(0).first : request.subdomains.first
    end
  
  private
    def instance
      instance_variable_get "@#{Submarine.subdomain_model}"
    end
end 