[![Build Status](https://github.com/Suban05/yaip/workflows/Ruby/badge.svg)](https://github.com/Suban05/yaip/actions)

# Yaip - Yet another IP Geolocation API Client

**Yaip** is a simple Ruby client for the IP Geolocation API, which retrieves geolocation data based on an IP address. This client uses `http://ip-api.com` to fetch IP information in XML format.

## Features

- Fetches geolocation information for a given IP address.
- Supports fetching specific fields with optional query parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yaip", git: "https://github.com/Suban05/yaip"
```

And then execute:

```bash
bundle install
```

## Usage

You can use the `Yaip::Ipgeobase.lookup` method to fetch geolocation data for an IP address.

### Example

```ruby
require 'yaip'

# Fetch full geolocation data for an IP
ip_meta = Yaip::Ipgeobase.lookup("83.169.216.199")
puts ip_meta.city # => "Yekaterinburg"
puts ip_meta.country # => "Russia"

# Fetch only specific fields with optional parameters
ip_meta = Yaip::Ipgeobase.lookup("83.169.216.199", "fields" => "status,org,country,zip,region")
puts ip_meta.org # => "PJSC MegaFon GPRS/UMTS Network"
```

## Running Tests

To run the test suite, first install the necessary dependencies:

```bash
bundle install
```

Then, you can run the tests with:

```bash
rake test
```

The tests use WebMock to stub external API requests.
