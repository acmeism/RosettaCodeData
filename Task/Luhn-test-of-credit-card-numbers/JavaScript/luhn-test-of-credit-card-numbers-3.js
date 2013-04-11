var luhn10 = function(a,b,c,d,e) {
  for(d = +a[b = a.length-1], e=0; b--;)
    c = +a[b], d += ++e % 2 ? 2 * c % 10 + (c > 4) : c;
  return !(d%10)
}

// returns true
luhn10('4111111111111111')

// returns false
luhn10('4111111111111112')
