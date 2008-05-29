module Submarine
  
  class SubdomainModelError < StandardError; end
  class SubdomainColumnError < StandardError; end
  
  def self.included(controller)
    controller.helper_method(:method_missing, :submarine_url, :submarine_host, :submarine_domain, :current_subdomain)
  end
  
  def subdomain_model; 'user' end
  def subdomain_column; 'login' end
  
protected

  def method_missing(method_id, *args)
    method_name = method_id.to_s
    setter = method_name.chomp!("=") 
    model_name, method_name = method_name.split("_").first, method_name.split("_").last
    if model_name == subdomain_model && %w(url host domain).include?(method_name)
      send("submarine_#{method_name}")
    else
      super
    end
  end

  def default_submarine_subdomain
    raise SubdomainModelError.new("@#{subdomain_model} instance variable not found") if instance.nil?
    raise SubdomainColumnError.new("@#{subdomain_model} does not have a '#{subdomain_column}' attribute") unless instance.respond_to?(subdomain_column)
    instance.send(subdomain_column)
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
    instance_variable_get "@#{subdomain_model}"
  end
end 