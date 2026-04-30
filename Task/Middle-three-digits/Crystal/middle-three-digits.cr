struct Int
  def mtd
    n = self.abs
    raise "Not enough digits" unless n >= 100
    ds = n.digits
    raise "Even digits"       unless ds.size.odd?
    ds[ds.size // 2 - 1, 3].reverse
  end
end

puts "Should succeed:"
[123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345].each do |n|
  printf "%10d: %s\n", n, n.mtd
end
puts "Should fail:"
[1, 2, -1, -10, 2002, -2002, 0].each do |n|
  printf "%10d: ", n
  begin
    puts n.mtd
  rescue ex
    puts ex.message
  end
end
