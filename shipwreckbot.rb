#!/usr/bin/env ruby
require_relative 'imessage.rb'
include IMessage

TEXT_SCRIPT_PATH = "#{DIR}/imessage_txt.scpt"
SLEEP = 60*5
ADJECTIVES = ['creepy', 'sunken', 'eerie', 'rusty']
NOUN = "great lakes shipwrecks"
DURATION = 60*60*2

start = Time.now
while true and (DURATION.nil? or Time.now < start + DURATION)
  IMessage.send_picture(ARGV[0], NOUN, ADJECTIVES)
  sleep SLEEP
end

`osascript #{TEXT_SCRIPT_PATH} #{number} 'shipwreck bot says goodnight!'`
