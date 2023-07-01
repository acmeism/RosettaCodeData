struct Int
  def gapful?
    a = self.to_s.chars.map(&.to_i)
    self % (a.first*10 + a.last) == 0
  end
end

specs = {100 => 30, 1_000_000 => 15, 1_000_000_000 => 10, 7123 => 25}

specs.each do |start, count|
  puts "first #{count} gapful numbers >= #{start}:"
  i, gapful = 0, [] of Int32
  (start..).each { |n| n.gapful? && (gapful << n; i += 1); break if i == count }
  puts gapful, "\n"
end
