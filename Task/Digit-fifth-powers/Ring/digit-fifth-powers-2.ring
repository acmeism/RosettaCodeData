st = clock()
lst9 = 1:10 lst3 = 1:4
p5 = [] m5 = [] m4 = [] m3 = [] m2 = [] m1 = []
for i in lst9
  add(p5, pow(i - 1, 5)) add(m1, (i - 1) * 10) add(m2, m1[i] * 10)
  add(m3, m2[i] * 10) add(m4, m3[i] * 10) add(m5, m4[i] * 10)
next

s = 0 t = ""
for i in lst3 ip = p5[i] im = m5[i]
  for j in lst9 jp = ip + p5[j] jm = im + m4[j]
    for k in lst9 kp = jp + p5[k] km = jm + m3[k]
      for l in lst9 lp = kp + p5[l] lm = km + m2[l]
        for m in lst9 mp = lp + p5[m] mm = lm + m1[m]
          for n in lst9 np = mp + p5[n] nm = mm + n - 1
            if nm = np and nm > 1
              if t != "" t += " + " ok
              s += nm t += nm
            ok
next next next next next next
et = clock()
put t + " = " + s + "  " + (et - st) / clockspersecond() + " sec"
