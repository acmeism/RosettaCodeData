def factor_pairs n
  (2..n ** 0.5 + 1).map { |i| [i, n / i] if n % i == 0 }.compact
end

def vampire_factors n
  half = n.to_s.size / 2
  factor_pairs(n).select do |a, b|
    a.to_s.size == half && b.to_s.size == half &&
    [a, b].map { |x| x % 10 }.count(0) != 2    &&
    "#{a}#{b}".chars.sort == n.to_s.chars.sort
  end
end

i = vamps = 0
until vamps == 25
  vf = vampire_factors(i += 1)
  unless vf.empty?
    puts "#{i}\t#{vf}"
    vamps += 1
  end
end

[16758243290880, 24959017348650, 14593825548650].each do |n|
  puts "#{n}\t#{vf}" unless (vf = vampire_factors n).empty?
end
