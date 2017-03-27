#!/usr/bin/env ruby
require_relative 'imessage.rb'
include IMessage

SLEEP = 15
ADJECTIVES = ['cute', 'adorable']
NOUN = "puppies"

while true
  IMessage.send_picture(ARGV[0], NOUN, ADJECTIVES)
  sleep SLEEP
end