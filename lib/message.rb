# encoding: utf-8

class Message
  def initialize(line, socket)
    @line = line
    @socket = socket

    self.extend $config.to_module
  end

  def send(options)
    @socket.print("PRIVMSG #{options[:to]} :#{options[:body]}\r\n")
  end

  def caller
    if @line =~ /(.*)?!.*?PRIVMSG #{self.channel}/i
      return $1.gsub(/:/, '')
    end

    return nil
  end

  def body
    @line.partition(":")[2]
  end
end
