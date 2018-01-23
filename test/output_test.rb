require 'minitest'
require 'minitest/autorun'
require './lib/output'
require 'net/http'
require "uri"

class OutputTest < Minitest::Test
  def test_it_can_make_request
    output = Output.new
    output.make_request
    assert_equal 9, output.request_lines.length
  end
end
