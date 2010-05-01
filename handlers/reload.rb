# encoding: utf-8

add_handler(/!reload/) do |message|
  reload_handlers
  message.send :to => message.channel, :body => "#{message.caller}, configuração recarregada com sucesso."
end
