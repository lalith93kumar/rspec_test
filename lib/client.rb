require 'base64'
class Client

  attr_accessor :default_header
  attr_accessor :client
  attr_accessor :authenticate_using_csrf
  attr_accessor :authenticate_using_basic
  attr_accessor :basic_authentication
  attr_accessor :csrf_token
  attr_accessor :use_content_type_json
  attr_accessor :use_content_type_text
  attr_accessor :use_content_type_xml
  attr_accessor :use_content_type_www_form_urlencoded
  def initialize()
    @client = HTTPClient.new
  end

  ################# GET

  def get(uri = '/', query = {}, header = {})
    header = setup_header(header)
    @client.request('GET', uri, query, nil, header)
  end

  ################# POST

  def post(uri = '/', body = {}, header = {}, query = {})
    header = setup_header(header)
    @client.request('POST', uri, query, body, header)
  end

  ################# PATCH

  def patch(uri = '/', body = {}, header = {}, query = {})
    header = setup_header(header)
    @client.request('PATCH', uri, query, body, header)
  end

  ################# PUT

  def put(uri = '/', body = {}, header = {}, query = {})
    header = setup_header(header)
    @client.request('PUT', uri, query, body, header)
  end


  ################# DELETE

  def delete(uri = '/', body = {}, header = {}, query = {})
    header = setup_header(header)
    @client.request('DELETE', uri, query, body, header)
  end

  ################# Authentication

  # Basic
  def set_basic_auth(username, password)
    @authenticate_using_basic = true
    @basic_authentication = "Basic #{Base64.strict_encode64(username + ':' + password)}".strip
  end

  def unset_basic_auth
    @authenticate_using_basic = false
  end

  #CSRF
  def unset_csrf_auth
    @authenticate_using_csrf = false
  end

  ################# Configuration

  def setup_header(header)
    header["Authorization"]   = @basic_authentication if @authenticate_using_basic && !@basic_authentication.nil?
    header["X-CSRF-Token"]    = @csrf_token if @authenticate_using_csrf && !@csrf_token.nil?
    header["Content-Type"]    = "application/json" if @use_content_type_json
    header["Content-Type"]    = "application/text" if @use_content_type_text
    header["Content-Type"]    = "application/xml" if @use_content_type_xml
    header["Content-Type"]    = "application/x-www-form-urlencoded" if @use_content_type_www_form_urlencoded
    header
  end

  def cookie_manager
    @client.cookie_manager
  end
end
