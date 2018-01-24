require 'minitest'
require 'pry'
require 'minitest/autorun'
require 'net/http'
require 'uri'

class ServerTest < Minitest::Test
  def setup
    uri = URI.parse('http://localhost:9292')
    Net::HTTP.get_response(uri)
    @response = Net::HTTP.get_response(uri)
  end

  def test_that_it_increments
    # binding.pry
    assert_includes @response.body, 'Hello, World! (2)'
  end

  # def test_it_returns_the_diagnostics
  #   skip
  # end
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
