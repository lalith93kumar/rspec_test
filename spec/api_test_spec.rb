require 'rspec/core'
require 'httpclient'
require 'byebug'
require "json-schema"
require_relative "../lib/client.rb"
RSpec.describe "Api Test to comapare response data & artifacts" do
  before(:all) do
    @client = Client.new
  end
  after(:each) do |e|
    if e.exception.nil?
      puts e.description + ": Passed\n"
    else
      puts e.description + ": Failed\n"
    end
  end
  file1 = File.new('testData/file1.txt')
  file2 = File.new('testData/file2.txt') # It Dose't load the hole file into memory. It create a poniter to intial line of the file
  loop do
    begin
      file1_request = file1.readline.gsub("\n",'') # it loads reads single line from the file and moves the pointer to next line.
      file2_request = file2.readline.gsub("\n",'')
    rescue
      break
    end
    it "File 1 : #{file1_request} & File 2 : #{file2_request}"  do
      response_file1 = @client.get(file1_request)
      response_file2 = @client.get(file2_request)
      res_body_1 = response_body_to_hash(response_file1)
      res_body_2 = response_body_to_hash(response_file2)
      aggregate_failures "Body Respone Comparing" do
        expect(deep_diff(res_body_1,res_body_2).keys).to match_array([]),"values that not common for both #{deep_diff(res_body_1,res_body_2)}"
      end
      aggregate_failures "Respone Headers Comparing" do
        (response_file1.headers.keys+response_file2.headers.keys).reject{|x| ['CF-RAY','Age','CF-Cache-Status','Date','Expires'].include?(x)}.uniq.each do |x|
          expect(response_file1.headers[x]).to eq(response_file2.headers[x]),"Headers values key #{x}: file1 value #{response_file1.headers[x]}:file1 value #{response_file2.headers[x]}"
        end
      end
      aggregate_failures "Respone Artifacts Comparing" do
        expect(response_file1.http_version).to eq(response_file2.http_version)
        expect(response_file1.status_code).to eq(response_file2.status_code)
        expect(response_file1.reason).to eq(response_file2.reason)
        expect(response_file1.ok?).to eq(response_file2.ok?)
        expect(response_file1.ok?).to eq(response_file2.ok?)
      end
    end
  end
end

def deep_diff(a, b)
  (a.keys | b.keys).each_with_object({}) do |k, diff|
    if a[k] != b[k]
      if a[k].is_a?(Hash) && b[k].is_a?(Hash)
        diff[k] = deep_diff(a[k], b[k])
      else
        diff[k] = [a[k], b[k]]
      end
    end
    diff
  end
end

def response_body_to_hash(res)
  if res.content_type!=nil  && res.content_type.include?('application/json')
    return JSON.parse(res.body)
  elsif res.content_type!=nil  && res.content_type.include?('application/xml')
    return Hash.from_xml(res.body)
  else
    return {}
  end
end
