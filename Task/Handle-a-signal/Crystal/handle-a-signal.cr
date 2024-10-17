start = Time.utc
ch = Channel(Int32 | Symbol).new

spawn do
  i = 0
  loop do
    sleep 1
    ch.send(i += 1)
  end
end

Signal::INT.trap do
  Signal::INT.reset
  ch.send(:kill)
end

loop do
  x = ch.receive
  break if x == :kill
  puts x
end

elapsed = Time.utc - start
puts "Program has run for %5.3f seconds." % elapsed.total_seconds
