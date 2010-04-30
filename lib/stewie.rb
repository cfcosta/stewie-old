# encoding: utf-8

require 'socket'

class Stewie
  def set(options)
    self.extend options.to_module
  end

  def add_handler(pattern, &block)
    @handlers ||= {}

    raise HandlerError "Handler already defined!" if @handlers[pattern]
    @handlers[pattern] = block
  end

  def connect!
    puts "Welcome to StewieBot!"

    live_connection do |message|
      @handlers.each do |pattern, block|
        break block.call if message.match pattern
      end
    end
  end

private
  def live_connection
    begin
      TCPSocket.open(server, port) do |sock|
        sock.print("USER #{nickname} #{nickname} #{nickname} :StewieBot :)\r\n")
        sock.print("NICK #{nickname}\r\n")
        sock.print("JOIN #{channel}\r\n")

        while !sock.closed?
          yield sock.readline.chomp
        end
      end
    rescue SocketError => e
      puts "Could not connect to server #{server}:"
      puts "  #{e.message}"

      exit 1
    end
  end
end
