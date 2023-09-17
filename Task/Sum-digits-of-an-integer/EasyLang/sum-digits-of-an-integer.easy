func sumdig s$ .
   for c$ in strchars s$
      h = strcode c$ - 48
      if h >= 10
         h -= 39
      .
      r += h
   .
   return r
.
print sumdig "1"
print sumdig "1234"
print sumdig "fe"
print sumdig "f0e"
