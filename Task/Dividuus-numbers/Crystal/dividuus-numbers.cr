struct Int
  def dividuus?
    return false  unless self >= 1
    # Digital root
    dr = 1 + (self - 1) % 9
    return false  unless dr > 0 && self % dr == 0
    ds = digits
    # Digital sum
    return false  unless self % ds.sum == 0
    # Digital product
    product = ds.product
    return false  unless product > 0 && self % product == 0
    # Multiplicative digital root
    while product >= 10
      product = product.digits.product
    end
    return product > 0 && self % product == 0
  end
end

puts "First 50 dividuus numbers:"
puts (1..).each.select(&.dividuus?).first(50).to_a
puts
puts "Dividuus numbers between 990 million and one billion:"
puts (990_000_000..1_000_000_000).select(&.dividuus?).to_a
