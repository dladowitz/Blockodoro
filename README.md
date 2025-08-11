# Blockodoro
### Pomodoro, but using the Bitcoin Blockchain
Written as a simple Ruby script.
Currently only tested in an OSX Terminal

1. Open the Terminal app. 
Ensure you have ruby on your computer
```
> ruby -v
ruby 3.3.0
```

2. Download the [block_monitor.rb](https://github.com/dladowitz/Blockodoro/blob/main/block_monitor.rb) file 
3. In the Terminal navigate to where ever you have the file saved. 
4. Run the block monitor using Ruby
```
>  ruby block_monitor.rb

🔍 Monitoring Bitcoin blockchain for new blocks...
Press Ctrl+C to stop

Current block height: 909475

Polling
....
````

You'll see one dot each time the monitor polls for new blocks

When a new block is found you'll be alerted

```
🎉 New block found!
Height: 909476
Hash: 000000000000000000001457deb64d6272e5282c11d42edb8c38442be3b1930e
Time: 2025-08-10 16:19:03
Size: 2206462 bytes
Transaction count: 2363
```



### Error
The script finds the first new block properly. Then when new blocks are found instead of alerting properly, this error message shows up:
"Error fetching block info: bad URI (is not URI?): "https://blockstream.info/api/block/Block not found". 
