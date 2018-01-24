module HtmlContent
  def headers
    ["http/1.1 200 ok",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def body
    "Hello, World! (#{@requests}) <pre>#{parse_diagnostic}</pre>"
  end

  def response
    "<pre>" + request_lines.join("\n") + "</pre>"
  end

  def output
    "<html><head></head><body>#{body}</body></html>"
  end
end
