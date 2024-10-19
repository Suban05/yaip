# frozen_string_literal: true

require "net/http"
require "addressable/template"
require "happymapper"

module Yaip
  # The Ipgeobase client
  class Ipgeobase
    def self.lookup(ip, params = {})
      query = ""
      query = "{?query*}" if params.any?
      uri = Addressable::Template.new("http://ip-api.com/xml/#{ip}#{query}")
                                 .expand("query" => params)
      hostname = uri.hostname
      req = Net::HTTP::Get.new(uri)
      res = Net::HTTP.start(hostname) do |http|
        http.request(req)
      end
      HappyMapper.parse(res.body)
    end
  end
end
