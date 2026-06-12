digit_sum = ->(n) { n.digits.sum }
digit_prod = ->(n) { n.digits.reduce(:*) }
digital_root = ->(n) { n.positive? ? 1 + ((n - 1) % 9) : 0 }

multi_digital_root = lambda { |n|
  n = n.digits.reduce(:*) while n >= 10
  n
}

is_dividuus = lambda { |n|
  [digit_sum, digit_prod, digital_root, multi_digital_root].each do |f|
    m = f.call(n)
    return false if m.zero? || n % m != 0
  end
  true
}

puts "First fifty Dividuus numbers:"
p (1..).lazy.select(&is_dividuus).first(50)

puts "\nDividuus numbers between 990,000,000 and 1,000,000,000:"
p (990_000_000..1_000_000_000).select(&is_dividuus)
