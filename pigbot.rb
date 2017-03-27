#!/usr/bin/env ruby
require_relative 'imgur_imessage.rb'
include Imgur

SLEEP = 60*5
ADJECTIVES = ['cute', 'adorable']
NOUN = "baby pigs"

while true
  Imgur.send_picture(ARGV[0], NOUN, ADJECTIVES)
  sleep SLEEP
end