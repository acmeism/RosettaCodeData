class Array
  def knuth_shuffle!
    j = length
    i = 0
    while j > 1
      r = i + rand(j)
      self[i], self[r] = self[r], self[i]
      i += 1
      j -= 1
    end
    self
  end
end

r = Hash.new(0)
100_000.times do |i|
  a = [1,2,3].knuth_shuffle!
  r[a] += 1
end

r.keys.sort.each {|a| puts "#{a.inspect} => #{r[a]}"}
