require 'minitest'
require 'minitest/autorun'
require './lib/output'
require 'net/http'
require "uri"

class OutputTest < Minitest::Test
  def test_it_can_make_request
    skip
    output = Output.new
    output.start_server
    assert_equal 9, output.request_lines.length
    assert_equal 1, output.counter
    output.stop_server
  end

  def test_that_it_increments
    output = Output.new
    output.start_server
    assert_equal 2, output.counter
    output.stop_server
  end
end
