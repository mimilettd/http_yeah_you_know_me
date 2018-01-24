require 'socket'
require 'pry'

class Server
  attr_reader :tcp_server,
              :request_lines,
              :counter

  def initialize
    @request_lines = []
    @requests = 0
  end

  def increment_request_count
    @requests += 1
  end

  def start
    @tcp_server = TCPServer.new(9292)
    loop do
      increment_request_count
      @client = tcp_server.accept
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
        if line.include?("/resetcount")
          reset_request_count
        end
      end

      # if @request_lines[0].each do |line|
      #   line.include?("/resetcount")
      # end

      puts request_lines.inspect

      response = "<pre>" + request_lines.join("\n") + "</pre>"
      body = "Hello, World! (#{@requests})"
      output = "<html><head></head><body>#{body}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      @client.puts headers
      @client.puts output
      stop
    end
  end

  def reset_request_count
    @requests = 0
  end

  def stop
    @client.close
  end
end
