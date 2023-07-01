nivens = Enumerator.new {|y| (1..).each {|n| y << n if n.remainder(n.digits.sum).zero?} }

cur_gap = 0
puts 'Gap    Index of gap  Starting Niven'

nivens.each_cons(2).with_index(1) do |(n1, n2), i|
  break if i > 10_000_000
  if n2-n1 > cur_gap then
    printf "%3d %15s %15s\n", n2-n1, i, n1
    cur_gap = n2-n1
  end
end
