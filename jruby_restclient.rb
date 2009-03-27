require 'java'
require File.dirname(__FILE__) + '/commons-codec-1.3.jar'
require File.dirname(__FILE__) + '/commons-httpclient-3.1.jar'

require 'cgi'

module JRestClient  
  include_package 'org.apache.commons.httpclient'
  include_package 'org.apache.commons.httpclient.methods'
  include_package 'org.apache.commons.httpclient.params'    
  include_class 'org.apache.commons.httpclient.params.HttpMethodParams'  

  class << self
    attr_accessor :timeout
  end

  def self.get(url, headers = {})
    client = get_client
    method = GetMethod.new(url)
    set_headers(method, headers)    
    make_request(client, method)
  end
  
  def self.post(url, payload, headers = {})
    client = get_client
    method = PostMethod.new(url)
    set_headers(method, headers)
    
    unless payload.is_a? String
      payload = payload.collect { |key, value| "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"}.join("&")
    end
    
    method.setRequestBody(payload);    
    make_request(client, method)
  end
  
  protected
  
  def self.get_client
    client = HttpClient.new
    
    # Blah blah blah this is deprecated blah blah blah
    client.timeout = timeout if timeout
    
    client
  end
  
  def self.make_request(client, method)
    status = client.executeMethod(method)
    response = method.responseBody
    method.releaseConnection

    java.lang.String.new(response).to_s
  end
  
  def self.set_headers(method, headers)
    headers.each { |key, value| method.setRequestHeader(key.to_s, value.to_s) }
  end
  
end





