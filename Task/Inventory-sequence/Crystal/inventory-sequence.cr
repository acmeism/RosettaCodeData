def inventory
  i = 0
  counts = Hash(Int32, Int32).new(0)

  Iterator.of {
    count = counts[i]
    i = count.zero? ? 0 : i + 1
    counts[count] += 1
    count
  }
end

puts "Inventory sequence, first 100 elements:",
     inventory.first(100)
       .map {|n| " %2d" % n }.each_slice(20).map(&.join).join("\n")
puts
limits = (1000..10_000).step(1000).each
limit = limits.next
inventory.with_index do |n, i|
  break if limit.is_a? Iterator::Stop
  if n >= limit
    puts "First element >= %5d is %5d at index %d" % {limit, n, i}
    limit = limits.next
  end
end
