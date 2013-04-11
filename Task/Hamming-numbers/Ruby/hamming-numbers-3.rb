start = Time.now

idx = 1
hamming.each do |ham|
  case idx
  when (1..20), 1691
    p [idx, ham]
  when 1_000_000
    p [idx, ham]
    break
  end
  idx += 1
end

puts "elapsed: #{Time.now - start} seconds"
