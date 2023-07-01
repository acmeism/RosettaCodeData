# Project : Population count

odds = []
evens = []
pows = []

for n = 0 to 59
      if n < 30 add(pows, onesCount(pow(3, n))) ok
      num = onesCount(n)
      if num & 1 = 0 add(evens, n) else add(odds, n) ok
next

showOne("3^x:", pows)
showOne("Evil numbers:", evens)
showOne("Odious numbers:", odds)

func onesCount(b)
      c = 0 m = 50
      while b > 0
            p = pow(2, m)
            if b >= p b -= p c++ ok
            m--
      end return c

func arrayToStr(ary)
      res = "[" s = ", "
      for n = 1 to len(ary)
            if ary[n] < 10 res += " " ok
            if n = len(ary) s = "]" ok
            res += "" + ary[n] + s
      next return res

func showOne(title, ary)
      ? title
      ? arrayToStr(ary) + nl
