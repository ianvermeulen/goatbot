#!/usr/bin/env ruby
require 'net/http'
require 'json'

# Google specific constants
GOOGLE_ENDPOINT = "https://www.googleapis.com/customsearch/v1"
CX = "003134929712196864734%3Afkdf42pfjbu"
GOOGLE_API_KEY = "AIzaSyBMrhwcn-iF7Fx6kGiMEu6l9b5znXJPrss"

# Pixabay specific constants
PIXABAY_API_KEY = "4241636-a0e075777a48d675c8b21d327"
PIXABAY_ENDPOINT = "https://pixabay.com/api/"

# Flickr specific constants
FLICKR_API_KEY = "c7ca55b36efd89c2dd8b979aa031c746"
FLICKR_ENDPOINT = "https://api.flickr.com/services/rest"

PER_PAGE = 100
DIR = File.expand_path(File.dirname(__FILE__))
SCRIPT_PATH = "#{DIR}/imessage.scpt"

def backticks(cmd)
  `#{cmd} 2>&1 1>/dev/null`
end

module IMessage
  def send_picture(number, noun, adjectives)
    check_number(number)

    # clean search terms for request
    adjectives = adjectives.map { |adj| clean_get_param(adj) }
    noun =  clean_get_param(noun)
    image_path = "#{DIR}/#{noun}.jpg"
    backticks("rm #{image_path}")

    while !File.exists?(image_path) or File.zero?(image_path)
      # determine which image service to use
      # service = rand(3)
      service = 0 # this means use google
      

      query = adjectives.reduce(noun) { |query, adj| rand(2)==1 ? "#{adj}+#{query}" : query }
      params, endpoint = case service
                         when 0 then [google_params(query), GOOGLE_ENDPOINT]
                         when 1 then [pixabay_params(query), PIXABAY_ENDPOINT]
                         when 2 then [flickr_params(query), FLICKR_ENDPOINT]
                         end
      params = params.reduce("?") { |str, (k, v)| str + "#{k}=#{v}&"}.chop
      result = Net::HTTP.get_response(URI("#{endpoint}#{params}"))
      image_uri = case service
                  when 0 then parse_google_json(result.body)
                  when 1 then parse_pixabay_json(result.body)
                  when 2 then parse_flickr_json(result.body)
                  end
      next if image_uri.nil?
      backticks("curl #{image_uri} -o #{image_path}")
      backticks("osascript #{SCRIPT_PATH} #{number} #{image_path}")
    end
  end

  private
  def check_number(number)
    raise "10-digit phone number required with no hyphens or parentheses, only numbers" unless number=~/\d{10}/ and number.length==10
  end

  def clean_get_param(param)
    param.strip.gsub(/\s+/, '+')
  end

  def google_params(query)
    { 
      q: query,
      key: GOOGLE_API_KEY,
      cx: CX,
      searchType: 'image',
      fileType: 'jpg',
      num: 1,
      start: 1+rand(100)
    }
  end

  def parse_google_json(body)
    json = JSON.parse(body)
    return nil unless json["items"] and json["items"].size > 0
    idx = rand(json["items"].size)
    json["items"][idx]["link"]
  end

  def pixabay_params(query)
    {
      q: query,
      key: PIXABAY_API_KEY,
      lang: "en"
    }
  end

  def parse_pixabay_json(body)
    json = JSON.parse(body)
    puts json.inspect unless json["totalHits"] and json["totalHits"].to_i > 0
    return nil unless json["totalHits"] and json["totalHits"] > 0 and 
    idx = rand(json["totalHits"].to_i)
    puts json["totalHits"].to_i unless json["hits"][idx]
    puts json["hits"].inspect unless json["hits"][idx]
    return nil unless json["hits"][idx]
    json["hits"][idx]["webformatURL"]
  end

  def flickr_params(query)
    {
      text: query,
      api_key: FLICKR_API_KEY,
      method: "flickr.photos.search",
      format: "json",
      per_page: "100"
    }
  end

  def parse_flickr_json(body)
    json = JSON.parse(body.sub("jsonFlickrApi(", '').chop)
    return nil unless json["photos"] and json["photos"]["total"]
    total = json["photos"]["total"].to_i
    return nil unless total > 0
    idx = rand([PER_PAGE, total].min)
    photo = json["photos"]["photo"][idx]
    "https://farm#{photo['farm']}.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
  end
end