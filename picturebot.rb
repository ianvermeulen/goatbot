#!/usr/bin/env ruby
require 'optparse'
require_relative 'imessage.rb'
include IMessage

options = {}
OptionParser.new do |opts|
  opts.on("--noun NOUN", "noun to search for, can be multiple words") { |noun| options[:noun] = noun }
  opts.on("--adjectives ADJECTIVE", Array, "adjectives to search for") { |adjectives| options[:adjectives] = adjectives }
  opts.on("--number NUMBER", "-n", "number to send the message to") { |number| options[:number] = number }
end

IMessage.send_picture(options[:number], options[:noun], options[:adjectives])