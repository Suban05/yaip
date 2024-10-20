# frozen_string_literal: true

require "test_helper"

class TestYaip < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Yaip::VERSION
  end

  def test_fetches_data_without_params # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    WebMock.disable_net_connect!
    ip = "83.169.216.199"
    stub_request(:get, "http://ip-api.com/xml/#{ip}")
      .to_return(
        body: "<query>
              <status>success</status>
              <country>Russia</country>
              <countryCode>RU</countryCode>
              <region>SVE</region>
              <regionName>Sverdlovsk Oblast</regionName>
              <city>Yekaterinburg</city>
              <zip>620002</zip>
              <lat>56.8456</lat>
              <lon>60.6083</lon>
              <timezone>Asia/Yekaterinburg</timezone>
              <isp>PJSC MegaFon</isp>
              <org>PJSC MegaFon GPRS/UMTS Network</org>
              <as>AS31224 PJSC MegaFon</as>
              <query>#{ip}</query>
              </query>"
      )
    ip_meta = Yaip::Ipgeobase.lookup(ip)
    refute(ip_meta.nil?)
    assert_equal("Yekaterinburg", ip_meta.city)
    assert_equal("success", ip_meta.status)
    assert_equal("Yekaterinburg", ip_meta.city)
    assert_equal("Russia", ip_meta.country)
    assert_equal("RU", ip_meta.country_code)
    assert_equal("56.8456", ip_meta.lat)
    assert_equal("60.6083", ip_meta.lon)
  end

  def test_fetches_information_with_params # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    WebMock.disable_net_connect!
    ip = "83.169.216.199"
    stub_request(:get, "http://ip-api.com/xml/#{ip}?fields=status,org,country,zip,region")
      .to_return(
        body: "<query>
              <status>success</status>
              <country>Russia</country>
              <region>SVE</region>
              <zip>620002</zip>
              <org>PJSC MegaFon GPRS/UMTS Network</org>
              </query>"
      )
    ip_meta = Yaip::Ipgeobase.lookup(ip, "fields" => "status,org,country,zip,region")
    refute(ip_meta.nil?)
    assert_equal("success", ip_meta.status)
    assert_equal("Russia", ip_meta.country)
    assert_equal("PJSC MegaFon GPRS/UMTS Network", ip_meta.org)
    assert_equal("620002", ip_meta.zip)
    assert_equal("SVE", ip_meta.region)
    refute(ip_meta.respond_to?(:country_code))
  end
end
