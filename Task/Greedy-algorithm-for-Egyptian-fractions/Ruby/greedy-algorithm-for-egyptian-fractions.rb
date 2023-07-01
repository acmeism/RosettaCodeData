def ef(fr)
  ans = []
  if fr >= 1
    return [[fr.to_i], Rational(0, 1)]  if fr.denominator == 1
    intfr = fr.to_i
    ans, fr = [intfr], fr - intfr
  end
  x, y = fr.numerator, fr.denominator
  while x != 1
    ans << Rational(1, (1/fr).ceil)
    fr = Rational(-y % x, y * (1/fr).ceil)
    x, y = fr.numerator, fr.denominator
  end
  ans << fr
end

for fr in [Rational(43, 48), Rational(5, 121), Rational(2014, 59)]
  puts '%s => %s' % [fr, ef(fr).join(' + ')]
end

lenmax = denommax = [0]
for b in 2..99
  for a in 1...b
    fr = Rational(a,b)
    e = ef(fr)
    elen, edenom = e.length, e[-1].denominator
    lenmax = [elen, fr] if elen > lenmax[0]
    denommax = [edenom, fr] if edenom > denommax[0]
  end
end
puts 'Term max is %s with %i terms' % [lenmax[1], lenmax[0]]
dstr = denommax[0].to_s
puts 'Denominator max is %s with %i digits' % [denommax[1], dstr.size], dstr
