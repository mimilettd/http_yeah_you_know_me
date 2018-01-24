require 'socket'
require 'pry'

class Output
  attr_reader :tcp_server,
              :client,
              :request_lines,
              :output,
              :counter
  def initialize
    @request_lines = []
    @counter = 0
  end

  def increment_counter
    @counter += 1
  end

  def start_server
    @tcp_server = TCPServer.new(9292)
    loop do
      increment_counter
      @client = tcp_server.accept
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      puts request_lines.inspect

      response = "<pre>" + request_lines.join("\n") + "</pre>"
      body = "Hello, World! (#{counter})"
      @output = "<html><head></head><body>#{body}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts @output
      stop_server
    end
  end

  def stop_server
    client.close
  end
end
