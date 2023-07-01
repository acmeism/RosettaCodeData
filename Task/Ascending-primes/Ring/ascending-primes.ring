show("ascending primes", sort(cending_primes(seq(1, 9))))

func show(title, itm)
  l = len(itm); ? "" + l + " " + title + ":"
  for i = 1 to l
    see fmt(itm[i], 9)
    if i % 5 = 0 and i < l? "" ok
  next : ? ""

func seq(b, e)
  res = []; d = e - b
  s = d / fabs(d)
  for i = b to e step s add(res, i) next
  return res

func ispr(n)
  if n < 2 return 0 ok
  if n & 1 = 0 return n = 2 ok
  if n % 3 = 0 return n = 3 ok
  l = sqrt(n)
  for f = 5 to l
    if n % f = 0 or n % (f + 2) = 0 return false ok
  next : return 1

func cending_primes(digs)
  cand = [0]
  pr = []
  for i in digs
    lcand = cand
    for j in lcand
      v = j * 10 + i
      if ispr(v) add(pr, v) ok
      add(cand, v)
    next
  next
  return pr

func fmt(x, l)
  res = "          " + x
  return right(res, l)
