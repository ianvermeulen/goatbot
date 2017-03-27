#!/usr/bin/env ruby
require_relative 'imessage.rb'
include IMessage

TEXT_SCRIPT_PATH = "#{DIR}/imessage_text.scpt"
SLEEP = (ARGV[2] || 60*5).to_i
DURATION = (ARGV[1] || 60*60).to_i
NUMBER = ARGV[0]

SEARCHES = {
  "kittens" => ['cute', 'adorable', 'tiny'],
  "baby goats" => ['cute', 'adorable', 'frolicking'],
  "puppies" => ['cute', 'fluffy', 'adorable'],
  "shipwrecks" => ['creepy', 'eerie', 'michigan'],
  "penguins" => ['cute', 'friendly'],
  "pandas" => ['cute', 'cuddly', 'happy']
}

start = Time.now
while Time.now < start + DURATION
  noun, adjectives = SEARCHES.to_a[rand(SEARCHES.size)]
  puts "#{((start + DURATION) - Time.now).round} seconds remaining. Searhing for #{adjectives.join(',')} #{noun}"
  IMessage.send_picture(ARGV[0], noun, adjectives)
  sleep SLEEP
end

# `osascript #{TEXT_SCRIPT_PATH} #{ARGV[0]} 'goatbot says goodnight!'`
