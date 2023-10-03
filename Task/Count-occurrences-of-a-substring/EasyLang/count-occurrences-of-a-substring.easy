func count str$ pat$ .
   ind = 1
   while ind + len pat$ - 1 <= len str$
      if substr str$ ind len pat$ = pat$
         cnt += 1
         ind += len pat$
      else
         ind += 1
      .
   .
   return cnt
.
print count "the three truths" "th"
print count "ababababab" "abab"
print count "11111111" "11"
print count "11111111" "12"
print count "12" "12"
