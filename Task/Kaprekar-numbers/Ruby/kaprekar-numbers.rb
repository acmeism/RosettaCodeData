def kaprekar(n, base = 10)
  return [1, 1, 1, ""] if n == 1
  return if n*(n-1) % (base-1) != 0     # casting out nine
  sqr = (n ** 2).to_s(base)
  (1...sqr.length).each do |i|
    a = sqr[0 ... i]
    b = sqr[i .. -1]
    break if b.delete("0").empty?
    sum = a.to_i(base) + b.to_i(base)
    return n.to_s(base), sqr, a, b if sum == n
  end
  nil
end

count = 0
1.upto(10_000 - 1) do |i|
  if result = kaprekar(i)
    puts "%4d  %8d  %s + %s" % result
    count += 1
  end
end

10_000.upto(1_000_000 - 1) {|i| count += 1 if kaprekar(i)}
puts "#{count} kaprekar numbers under 1,000,000"

puts "\nbase17 kaprekar numbers under (base10)1,000,000"
base = 17
1.upto(1_000_000) do |decimal|
  if result = kaprekar(decimal, base)
    puts "%7s  %5s  %9s  %s + %s" % [decimal, *result]
  end
end
