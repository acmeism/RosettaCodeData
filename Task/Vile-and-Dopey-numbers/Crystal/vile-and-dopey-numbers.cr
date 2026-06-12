struct Int
  def vile?
    trailing_zeros_count % 2 == 0
  end

  def dopey?
    ! vile?
  end
end

puts "First 25 Vile numbers:"
puts (1..).each.select(&.vile?).first(25).to_a

puts "First 25 Dopey numbers:"
puts (1..).each.select(&.dopey?).first(25).to_a

puts "upto:  Vile  Dopey"
(1..10).map {|n| 2**n }.accumulate({ 0, 0 }) {|(prev_upto, qty), upto|
  { upto, qty + ((prev_upto+1)..upto).count(&.vile?) }
}[1..].each do |upto, qty|
  printf "%4d:  %4d   %4d\n", upto, qty, upto-qty
end
