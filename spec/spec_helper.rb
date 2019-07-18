require 'rspec/core'
require 'httpclient'
require 'byebug'
require "json-schema"
require 'allure-rspec'
require_relative "../lib/client.rb"
require_relative "../lib/utility.rb"
AllureRSpec.configure do |config|
  config.output_dir = "reports/allure"
  config.clean_dir = false
  config.logging_level = Logger::WARN
end
RSpec.configure do |config|
  config.include AllureRSpec::Adaptor
  config.formatter = :documentation
  config.before(:suite) do
    begin
      FileUtils.mkdir_p("#{Pathname.pwd}/reports/allure") unless File.file?("#{Pathname.pwd}/reports/allure/environment.properties")
      File.open("#{Pathname.pwd}/reports/allure/environment.properties", 'w') do |f|
        f.write("Report=Api Testing\n")
      end
    rescue Exception => e
      puts e.message
    end
  end
end
