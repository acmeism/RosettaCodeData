def aliquot(n, maxlen=16, maxterm=2**47)
  return "terminating", [0] if n == 0
  s = []
  while (s << n).size <= maxlen and n < maxterm
    n = n.proper_divisors.inject(0, :+)
    if s.include?(n)
      case n
      when s[0]
        case s.size
        when 1   then   return "perfect", s
        when 2   then   return "amicable", s
        else            return "sociable of length #{s.size}", s
        end
      when s[-1] then   return "aspiring", s
      else              return "cyclic back to #{n}", s
      end
    elsif n == 0 then   return "terminating", s << 0
    end
  end
  return "non-terminating", s
end

for n in 1..10
  puts "%20s: %p" % aliquot(n)
end
puts
for n in [11, 12, 28, 496, 220, 1184,  12496, 1264460, 790, 909, 562, 1064, 1488, 15355717786080]
  puts "%20s: %p" % aliquot(n)
end
