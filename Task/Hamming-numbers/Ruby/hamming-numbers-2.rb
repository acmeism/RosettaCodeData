start = Time.now

hamming.each.with_index(1) do |ham, idx|
  case idx
  when (1..20), 1691
    puts "#{idx} => #{ham}"
  when 1_000_000
    puts "#{idx} => #{ham}"
    break
  end
end

puts "elapsed: #{Time.now - start} seconds"
