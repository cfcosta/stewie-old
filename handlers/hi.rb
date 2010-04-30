# encoding: utf-8

add_handler(/!hi/) do
  send_message :to => current_channel, :body => "#{message_caller}, olá!"
end
