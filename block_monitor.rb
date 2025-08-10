#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'time'

BLOCKSTREAM_API = 'https://blockstream.info/api'
CHECK_INTERVAL = 5  # seconds

def fetch_latest_block
  uri = URI("#{BLOCKSTREAM_API}/blocks/tip/height")
  response = Net::HTTP.get(uri)
  response.to_i
rescue => e
  warn "Error fetching block height: #{e.message}"
  nil
end

def fetch_block_info(height)
  uri = URI("#{BLOCKSTREAM_API}/block-height/#{height}")
  block_hash = Net::HTTP.get(uri)
  
  uri = URI("#{BLOCKSTREAM_API}/block/#{block_hash}")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
rescue => e
  warn "Error fetching block info: #{e.message}"
  nil
end

def format_time(timestamp)
  time = Time.at(timestamp)
  time.strftime("%Y-%m-%d %H:%M:%S")
end

puts "🔍 Monitoring Bitcoin blockchain for new blocks..."
puts "Press Ctrl+C to stop"
puts

last_height = fetch_latest_block
puts "Current block height: #{last_height}"
puts "\nPolling"  # Start the polling indicator line

loop do
  current_height = fetch_latest_block
  
  if current_height && current_height > last_height
    block_info = fetch_block_info(current_height)
    
    if block_info
      print "\n\n"  # Clear the polling dots line and add a blank line
      puts "🎉 New block found!"
      puts "Height: #{current_height}"
      puts "Hash: #{block_info['id']}"
      puts "Time: #{format_time(block_info['timestamp'])}"
      puts "Size: #{block_info['size']} bytes"
      puts "Transaction count: #{block_info['tx_count']}"
      puts "Mined by: #{block_info['extras']['pool']['name']}" if block_info['extras']&.dig('pool', 'name')
      puts "\nPolling"  # Start a new polling line
    end
    
    last_height = current_height
  end

  print "."
  $stdout.flush  # Ensure the dot is displayed immediately
  sleep CHECK_INTERVAL
end
