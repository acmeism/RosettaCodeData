func$ mult a$ b$ .
   a[] = number strchars a$
   b[] = number strchars b$
   len r[] len a[] + len b[]
   for ib = len b[] downto 1
      h = 0
      for ia = len a[] downto 1
         h += r[ia + ib] + b[ib] * a[ia]
         r[ia + ib] = h mod 10
         h = h div 10
      .
      r[ib] += h
   .
   r$ = ""
   for i = 1 to len r[]
      if r$ <> "" or r[i] <> 0 or i = len r[]
         r$ &= r[i]
      .
   .
   return r$
.
print mult "18446744073709551616" "18446744073709551616"
