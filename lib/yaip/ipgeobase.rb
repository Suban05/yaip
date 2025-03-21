# frozen_string_literal: true

require "net/http"
require "addressable/template"
require "happymapper"

module Yaip
  # The Ipgeobase client
  class Ipgeobase
    def self.lookup(ip, params = {}) = new(ip, params).value

    def initialize(ip, params = {})
      @ip = ip
      @params = params
    end

    def value
      uri = Addressable::Template.new("http://ip-api.com/xml/#{@ip}#{query}")
                                 .expand("query" => @params)
      HappyMapper.parse(
        Net::HTTP.start(uri.hostname) do |http|
          http.request(Net::HTTP::Get.new(uri))
        end.body
      )
    end

    private

    def query = @params.any? ? "{?query*}" : ""
  end
end
