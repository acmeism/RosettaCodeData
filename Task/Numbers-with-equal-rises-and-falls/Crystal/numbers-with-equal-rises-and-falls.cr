struct Int
  def equal_rises_and_falls?
    n, prev = self.abs.divmod 10
    rf = 0
    while n > 0
      n, d = n.divmod 10
      rf += prev <=> d
      prev = d
    end
    rf == 0
  end
end

puts "First 200:"
puts (1..).each.select(&.equal_rises_and_falls?).first(200).to_a
puts
puts "The 10,000,000th:"
puts (1..).each.select(&.equal_rises_and_falls?).skip(9_999_999).next
