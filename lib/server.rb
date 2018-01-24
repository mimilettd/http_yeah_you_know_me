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
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
        if line.include?("/resetcount")
          reset_request_count
        end
      end

      new = @request_lines.map { |line| line.split(' ') }
      first_elem = new.shift
      return_hash = {"Verb:" => first_elem[0], "Path:" => first_elem[1], "Protocol:" => first_elem[2]}

      new.each do |array|
        return_hash[array[0]] = array[1]
      end

      return_hash['Host:'] = @request_lines.last.split(':')[1]
      return_hash['Port:'] = @request_lines.last.split(':').last

      puts request_lines.inspect

      response_diagnostics = ""

      return_hash.each do |k, v|
        response_diagnostics += "#{k} #{v} \n"
      end

      response = "<pre>" + request_lines.join("\n") + "</pre>"
      body = "Hello, World! (#{@requests}) <pre>#{response_diagnostics}</pre>"
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
