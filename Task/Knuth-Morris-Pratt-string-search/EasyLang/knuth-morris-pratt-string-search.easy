func[] kmp_table w$[] .
   len t[] len w$[]
   i = 2
   while i < len w$[]
      j = 0
      while i + j <= len w$[]
         if w$[i + j] = w$[j + 1]
            t[i + j] = t[i + j - 1] + 1
         else
            t[i + j] = 0
            j += 1
            break 1
         .
         j += 1
      .
      i += j
   .
   return t[]
.
func[] kmp_search s$ w$ .
   s$[] = strchars s$
   w$[] = strchars w$
   i = 1
   t[] = kmp_table w$[]
   while i <= len s$[] - len w$[] + 1
      for j = 1 to len w$[]
         if s$[i + j - 1] <> w$[j]
            i += t[j] + 1
            break 1
         .
      .
      if j > len w$[]
         p[] &= i
         i += 1
      .
   .
   return p[]
.
text1$ = "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented"
text2$ = "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
pat1$ = "put"
pat2$ = "and"
pat3$ = "alfalfa"
print "Found <" & pat1$ & "> at one-based: " & kmp_search text1$ pat1$
print "Found <" & pat2$ & "> at one-based: " & kmp_search text1$ pat2$
print "Found <" & pat3$ & "> at one-based: " & kmp_search text2$ pat3$
