struct Int
  def gapful?
    a = self.to_s.chars.map(&.to_i)
    self % (a.first*10 + a.last) == 0
  end
end

specs = {100 => 30, 1_000_000 => 15, 1_000_000_000 => 10, 7123 => 25}

specs.each do |start, count|
  puts "first #{count} gapful numbers >= #{start}:"
  puts (start..).each.select(&.gapful?).first(count).to_a, "\n"
end
