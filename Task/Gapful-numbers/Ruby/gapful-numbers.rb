class Integer
  def gapful?
    a = digits
    self % (a.last*10 + a.first) == 0
  end
end

specs = {100 => 30, 1_000_000 => 15, 1_000_000_000 => 10, 7123 => 25}

specs.each do |start, num|
  puts "first #{num} gapful numbers >= #{start}:"
  p (start..).lazy.select(&:gapful?).take(num).to_a
end
