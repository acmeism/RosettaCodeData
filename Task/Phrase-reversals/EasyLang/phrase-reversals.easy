func$[] rev a$[] .
   for i to len a$[] div 2
      swap a$[i] a$[$ - i + 1]
   .
   return a$[]
.
lin$ = "rosetta code phrase reversal"
print strjoin rev strchars lin$ ""
words$[] = strsplit lin$ " "
for w$ in words$[]
   write strjoin rev strchars w$ ""
   write " "
.
print ""
wordsr$[] = rev words$[]
for w$ in wordsr$[]
   write w$ & " "
.
