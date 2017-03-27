#!/usr/bin/env ruby
require_relative 'imessage.rb'
include IMessage

TEXT_SCRIPT_PATH = "#{DIR}/imessage_text.scpt"
SLEEP = (ARGV[2] || 60*5).to_i
ADJECTIVES = ['cute', 'adorable', 'playful', 'tiny']
NOUN = "puppies"
DURATION = (ARGV[1] || 60*60).to_i

start = Time.now
while Time.now < start + DURATION
  IMessage.send_picture(ARGV[0], NOUN, ADJECTIVES)
  sleep SLEEP
end

`osascript #{TEXT_SCRIPT_PATH} #{ARGV[0]} 'puppybot says goodnight!'`
