#!/usr/bin/env ruby
require_relative 'imessage.rb'
include IMessage

SLEEP = 60*5
ADJECTIVES = ['cute', 'adorable', 'jumping']
NOUN = "baby goats"

while true
  IMessage.send_picture(ARGV[0], NOUN, ADJECTIVES)
  sleep SLEEP
end