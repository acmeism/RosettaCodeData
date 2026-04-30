len pos[] 26
len tbl$[] 25
global iforj .
proc inittbl key$ ifj .
   iforj = ifj
   for c$ in strchars key$
      c = strcode c$
      if c >= 97 : c -= 32
      if c >= 65 and c <= 90 : alph$ &= strchar c
   .
   for i to 26
      pos[i] = -1
      c$ = strchar (i + 64)
      if c$ <> "J" and c$ <> "Q"
         alph$ &= c$
      elif c$ = "J" and ifj = 0
         alph$ &= c$
      elif c$ = "Q" and ifj = 1
         alph$ &= c$
      .
   .
   k = 1
   for ch$ in strchars alph$
      ch = strcode ch$ - 64
      if pos[ch] = -1
         tbl$[k] = ch$
         pos[ch] = k - 1
         k += 1
      .
   .
.
func$ codec txt$ dir .
   txt$[] = strchars txt$
   for i = 1 step 2 to len txt$
      ch1 = strcode txt$[i] - 64
      ch2 = strcode txt$[i + 1] - 64
      col1 = pos[ch1] mod 5
      row1 = pos[ch1] div 5
      col2 = pos[ch2] mod 5
      row2 = pos[ch2] div 5
      if row1 = row2
         col1 = (col1 + dir) mod 5
         col2 = (col2 + dir) mod 5
      elif col1 = col2
         row1 = (row1 + dir) mod 5
         row2 = (row2 + dir) mod 5
      else
         swap col1 col2
      .
      r$ &= tbl$[row1 * 5 + col1 + 1]
      r$ &= tbl$[row2 * 5 + col2 + 1]
   .
   return r$
.
func$ preptxt txt$ .
   for c$ in strchars txt$
      c = strcode c$
      if c >= 97 : c -= 32
      if c >= 65 and c <= 90
         c$ = strchar c
         if c$ = "J" and iforj = 1 : c$ = "I"
         if c$ = "Q" and iforj = 0 : c$ = ""
         txt$[] &= c$
      .
   .
   i = 1
   while i <= len txt$[]
      cur$ = txt$[i]
      i += 1
      if i <= len txt$[]
         nxt$ = txt$[i]
      else
         nxt$ = "X"
      .
      r$ &= cur$
      if nxt$ = cur$
         r$ &= "X"
      else
         r$ &= nxt$
         i += 1
      .
   .
   return r$
.
func$ encode txt$ .
   return codec preptxt txt$ 1
.
func$ decode txt$ .
   return codec txt$ 4
.
func$ digraph s$ .
   for c$ in strchars s$
      r$ &= c$
      cnt += 1
      if cnt mod 2 = 0 : r$ &= " "
   .
   return r$
.
inittbl "Playfair example" 1
enc$ = encode "Hide the gold in...the TREESTUMP!!"
print digraph enc$
print digraph decode enc$
