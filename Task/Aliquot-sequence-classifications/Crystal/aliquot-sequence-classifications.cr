def sum_proper_divisors (n)
  z = n.class.zero
  (z+1..n//2).sum(z) {|i| n % i == 0 ? i : 0 }
end

def aliquot (n)
  seq = [n]
  limit = 2_i64**47
  15.times do
    n = sum_proper_divisors(n)
    case n
    when 0         then return { "terminating", seq << n }
    when .>(limit) then return { "non-terminating", seq << n }
    when seq[0]    then return { case seq.size
                                 when 1 then "perfect"
                                 when 2 then "amicable"
                                 else "sociable"
                                 end, seq }
    when seq.last  then return { "aspiring", seq }
    when .in?(seq) then return { "cyclic", seq << n }
    end
    seq << n
  end
  { "non-terminating", seq }
end

(1..10).each do |i|
  kind, seq = aliquot(i)
  puts "%s: %s" % { kind, seq }
end
puts
[11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488].each do |i|
  kind, seq = aliquot(i)
  puts "%s: %s" % { kind, seq }
end
