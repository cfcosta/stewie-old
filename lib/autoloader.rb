# encoding: utf-8

require "./lib/dependencity.rb"

loader = Dependencity.new
loader.add_rule("top")
loader.add_dir("lib")
loader.add_dir("handlers")
loader.process_directories
