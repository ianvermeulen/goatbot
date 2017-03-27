#!/usr/bin/env ruby
require 'net/http'
require 'json'

# Imgur specific constants
IMGUR_ID = "1a59596232e0a08"
IMGUR_SECRET = "5510e81a6de205edc51627d511a4f3c0d01b1796"
IMGUR_QUERY_ENDPOINT = "https://api.imgur.com/3/gallery/search/"
IMGUR_FETCH_ENDPOINT = "https://api.imgur.com/3/image/"

DIR = File.expand_path(File.dirname(__FILE__))
SCRIPT_PATH = "#{DIR}/imessage.scpt"
PAGES = 10

module Imgur
  def send_picture(number, noun, adjectives)
    check_number(number)

    # clean search terms for request
    adjectives = adjectives.map { |adj| clean_get_param(adj) }
    noun =  clean_get_param(noun)
    image_path = "#{DIR}/#{noun}.jpg"
    `rm #{image_path}`

    while !File.exists?(image_path) or File.zero?(image_path)
      query = adjectives.reduce(noun) { |query, adj| rand(2)==1 ? "#{adj}+#{query}" : query }
      params = imgur_params(query).reduce("?") { |str, (k, v)| str + "#{k}=#{v}&"}.chop
      endpoint = IMGUR_QUERY_ENDPOINT
      puts "#{endpoint}#{params}"
      result = JSON.parse(`curl '#{endpoint}#{params}' -H "Authorization: Client-Id #{IMGUR_ID}"`)
      puts result.inspect
      idx = rand(result["data"].size)
      image_uri = "#{IMGUR_FETCH_ENDPOINT}#{result["data"][idx]["id"]}.jpg"
      puts "\n\n\n#{result["data"][idx]["id"].size}"
      sleep 1000000
      puts "fetching image from: #{image_uri}"
      `curl #{image_uri} -o #{image_path}`
      `osascript #{SCRIPT_PATH} #{number} #{image_path}`
    end
  end

  private
  def check_number(number)
    raise "10-digit phone number required with no hyphens or parentheses, only numbers" unless number=~/\d{10}/ and number.length==10
  end

  def clean_get_param(param)
    param.strip.gsub(/\s+/, '+')
  end

  def imgur_params(query)
    {
      q: query,
      q_type: 'jpg'
    }
  end

  def parse_imgur_json(body)

  end
end