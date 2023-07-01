def factorion?(n, base)
  n.digits(base).sum{|digit| (1..digit).inject(1, :*)} == n
end

(9..12).each do |base|
  puts "Base #{base} factorions: #{(1..1_500_000).select{|n| factorion?(n, base)}.join(" ")} "
end
