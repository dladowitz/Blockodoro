

**User**
 
I want you to create a new file. 
Here is what we are trying to do:

I want to be alerted when a new block is found in the Bitcoin blockchain. 

Look up an API or website you want to use for the source of the blockchain. 

A new block is found on average every 10 min. Sometimes they come much faster possibly every 30 seconds. Sometimes it takes 1 hr. 
We don't need high precision here. 
We just want to know roughly within 10 seconds of a block being found

---

**Cursor**

Let's use Blockstream's API - it's reliable, well-documented, and doesn't require authentication.

Let's create a simple Ruby script that polls the Blockstream API. We'll check for new blocks every 5 seconds, which will give us notification within about 10 seconds of a block being found.

```ruby
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

loop do
  current_height = fetch_latest_block
  
  if current_height && current_height > last_height
    block_info = fetch_block_info(current_height)
    
    if block_info
      puts "\n🎉 New block found!"
      puts "Height: #{current_height}"
      puts "Hash: #{block_info['id']}"
      puts "Time: #{format_time(block_info['timestamp'])}"
      puts "Size: #{block_info['size']} bytes"
      puts "Transaction count: #{block_info['tx_count']}"
      puts "Mined by: #{block_info['extras']['pool']['name']}" if block_info['extras']&.dig('pool', 'name')
      puts
    end
    
    last_height = current_height
  end
  
  sleep CHECK_INTERVAL
end
```

I've created a new script that:

1. Uses the Blockstream.info API (a reliable and well-maintained Bitcoin block explorer)
2. Polls for new blocks every 5 seconds
3. When a new block is found, displays:
   - Block height
   - Block hash
   - Timestamp
   - Block size
   - Number of transactions
   - Mining pool name (if available)

To run the script:
```
ruby block_monitor.rb
```

---

**User**

So far so good. However I want an indicator that polling is happening. Please output one period "." every time there is a poll happening. 
The next period should be added to the same line to the right.


---

**Cursor**

I'll modify the script to show polling activity with periods on the same line. We'll use `print` instead of `puts` for the periods and flush the output to ensure it displays immediately:

```ruby
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
 

```

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'time'

BLOCKSTREAM_API = 'https://blockstream.info/api'
CHECK_INTERVAL = 5  # seconds

def fetch_latest_block
  uri = URI("#{BLOCKSTREAM_API}/blocks/tip/height")

end

```

Now the script will:
1. Show "Polling" on a new line
2. Add a period (.) every 5 seconds on the same line
3. When a new block is found, it will:
   - Clear the polling line
   - Show the block information
   - Start a new "Polling" line with periods

Let's run it to see how it looks:

---

**User**

Oh super awesome, that worked

---

**Cursor**

Yes, it's working nicely! You can see it:
1. Shows the polling activity with dots (.....) on a single line
2. When it found block 909476, it cleared the line and showed all the block details
3. Then started a new polling line

The script is much simpler and more reliable than the WebSocket version, and it still gives us notifications within about 5-10 seconds of a new block being found.

Since you've deleted the old `block_alert.rb` file and this new solution is working well, would you like me to:
1. Add any additional features?
2. Adjust the polling interval?
3. Add or remove any of the block information that's displayed?

Or is it working exactly as you'd like it now?

