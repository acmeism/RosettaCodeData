require 'prime'

prime_gen = Prime.each
cur_prime = nil
sisyphi   = Enumerator.produce(1) {|n| n.even? ? n/2 : n += (cur_prime = prime_gen.next)}

sisyphi.first(100).each_slice(10){|s| puts "%4d"*s.size % s }

puts
prime_gen.rewind
counter = Hash.new(0)
count_until = 250
idx   = 1000
limit = 100_000_000
sisyphi.with_index(1) do |n, i|
  counter[n] += 1 if n < count_until
  if i == idx then
    puts "element %11d is %11d, with prime %11d" % [i, n, cur_prime]
    break if idx >= limit
    idx *= 10
  end
end

puts "\nThese numbers under #{count_until} do not occur in the first #{limit} terms:"
puts ((1...count_until).to_a - counter.keys).join ", "

freq, nums = counter.group_by{|k, v| v}.max
puts "\nThese numbers under #{count_until} occur most frequent (#{freq} times) in the first #{limit} terms:"
puts nums.map(&:first).sort.join(", ")
