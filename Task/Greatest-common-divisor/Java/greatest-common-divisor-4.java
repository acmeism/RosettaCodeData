public static long gcd(long u, long v){
  long t, k;

  if (v == 0) return u;

  u = Math.abs(u);
  v = Math.abs(v);
  if (u < v){
    t = u;
    u = v;
    v = t;
  }

  for(k = 1; (u & 1) == 0 && (v & 1) == 0; k <<= 1){
    u >>= 1; v >>= 1;
  }

  t = (u & 1) != 0 ? -v : u;
  while (t != 0){
    while ((t & 1) == 0) t >>= 1;

    if (t > 0)
      u = t;
    else
      v = -t;

    t = u - v;
  }
  return u * k;
}
