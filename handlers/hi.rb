# encoding: utf-8

add_handler(/!hi/) do |message|
  message.send :to => message.channel, :body => "#{message.caller}, hello!"
end
