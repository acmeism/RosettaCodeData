def s_or_n_creator (n, t : T.class) forall T
  arr = Array(T).new(n)
  i = 0
  ->(item : T) {
    i += 1
    if i <= n
      arr << item
    elsif rand(i) < n
      arr[rand(n)] = item
    end
    arr
  }
end

buckets = Array.new(10, 0)
100_000.times do
  s_or_n = s_or_n_creator 3, Int32
  (0...9).each do |i|
    s_or_n.call i
  end
  s_or_n.call(9).each do |i| buckets[i] += 1 end
end

puts buckets
