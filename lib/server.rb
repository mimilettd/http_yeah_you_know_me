require 'socket'
require 'pry'
require_relative 'html_content'

class Server
  include HtmlContent
  attr_reader :tcp_server,
              :request_lines,
              :counter

  def initialize
    @request_lines = []
    @requests = 0
  end

  def update_request_data
    @requests += 1
    @request_lines = []
  end

  def start
    @tcp_server = TCPServer.new(9292)
    puts "Server has started at port :9292"
    loop do
      update_request_data
      @client = tcp_server.accept

      parse_lines

      puts request_lines.inspect
      @client.puts headers
      @client.puts output
      stop
    end
  end

  def parse_lines
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
      if line.include?("/resetcount")
        reset_request_count
      end
    end
  end

  def parse_diagnostic
    response_diagnostics = ""

    diagnostic_hash.each do |k, v|
      response_diagnostics += "#{k} #{v} \n"
    end

    response_diagnostics
  end

  def diagnostic_hash
    request_array = @request_lines.map { |line| line.split(' ') }
    http_verb_array = request_array.shift
    request_hash = {"Verb:" => http_verb_array[0], "Path:" => http_verb_array[1], "Protocol:" => http_verb_array[2]}

    request_array.each do |array|
      request_hash[array[0]] = array[1]
    end

    request_hash['Host:'] = @request_lines.last.split(':')[1]
    request_hash['Port:'] = @request_lines.last.split(':').last

    request_hash
  end

  def reset_request_count
    @requests = 0
  end

  def stop
    @client.close
  end
end
