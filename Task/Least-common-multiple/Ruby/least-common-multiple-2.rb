def gcd(m, n)
  m, n = n, m % n until n.zero?
  m.abs
end

def lcm(*args)
  args.inject(1) do |m, n|
    return 0 if n.zero?
    (m * n).abs / gcd(m, n)
  end
end

p lcm 12, 18, 22
p lcm 15, 14, -6, 10, 21
