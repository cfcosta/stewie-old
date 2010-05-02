# encoding: utf-8

require 'socket'

class Stewie
  def initialize
    self.extend $config.to_module
  end

  def connect!
    puts "Welcome to StewieBot!"

    live_connection do |line, socket|
      message = Message.new(line, socket)
      @handlers.each do |pattern, block|
        break block.call(message) if message.body.match pattern
      end
    end
  end

  def load_handlers
    Dir.glob("handlers/*.rb").each do |file|
      eval File.read(file)
    end
  end

  def add_handler(pattern, &block)
    @handlers ||= {}

    raise HandlerError "Handler already defined!" if @handlers[pattern]
    @handlers[pattern] = block
  end

  def reload_handlers
    @handlers = {}
    load_handlers
  end

private
  def live_connection
    begin
      TCPSocket.open(server, port) do |sock|
        sock.print("USER #{nickname} #{nickname} #{nickname} :StewieBot :)\r\n")
        sock.print("NICK #{nickname}\r\n")
        sock.print("JOIN #{channel}\r\n")

        while !sock.closed?
          line = sock.readline.chomp
          sock.print("PONG #{$1}\r\n") if line =~ /PING :(.*)/
          yield line, sock
        end
      end
    rescue SocketError => e
      puts "Could not connect to server #{server}:"
      puts "  #{e.message}"

      exit 1
    end
  end
end
