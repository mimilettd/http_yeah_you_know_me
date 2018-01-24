require 'minitest'
require 'pry'
require 'minitest/autorun'
require 'net/http'
require 'uri'

class ServerTest < Minitest::Test
  def request(number = 1)
    response = nil
    uri = URI.parse('http://localhost:9292')
    number.times do
      response = Net::HTTP.get_response(uri)
    end
    response
  end

  def reset_request_count
    uri_reset = URI.parse('http://localhost:9292/resetcount')
    Net::HTTP.get_response(uri_reset)
  end

  def test_that_it_increments
    reset_request_count
    response = request(2)
    assert_includes response.body, 'Hello, World! (2)'
  end

  def test_it_returns_the_diagnostics
    response = request
    assert_includes response.body, 'Verb: GET'
    assert_includes response.body, 'Path: /'
    assert_includes response.body, 'Protocol: HTTP/1.1'
    assert_includes response.body, 'Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
    assert_includes response.body, 'Accept: */*'
    assert_includes response.body, 'User-Agent: Ruby'
    assert_includes response.body, 'Host:  localhost'
    assert_includes response.body, 'Port: 9292'
  end
end

# Iteration 1 - Outputting Diagnostics
# Let’s start to rip apart that request and output it in your response. In the body of your response, include a block of HTML like this including the actual information from the request:
#
# <pre>
# Verb: POST
# Path: /
# Protocol: HTTP/1.1
# Host: 127.0.0.1
# Port: 9292
# Origin: 127.0.0.1
# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
# </pre>
# Keep the code that outputs this block at the bottom of all your future outputs to help with your debugging.
