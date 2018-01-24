require 'minitest'
require 'minitest/autorun'
require 'net/http'
require "uri"

class OutputTest < Minitest::Test
  def test_that_it_increments
    uri = URI.parse("http://localhost:9292")
    Net::HTTP.get_response(uri)
    response = Net::HTTP.get_response(uri)

    assert_equal response.body, "<html><head></head><body>Hello, World! (2)</body></html>"
  end
end
