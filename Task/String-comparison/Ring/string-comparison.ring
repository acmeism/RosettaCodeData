   if s1 = s2
      See "The strings are equal"
   ok
   if not (s1 = s2)
      See "The strings are not equal"
   ok
   if strcmp(s1,s2) > 0
      see "s2 is lexically ordered before than s1"
   ok
   if strcmp(s1,s2) < 0
      see "s2 is lexically ordered after than s1"
   ok

To achieve case insensitive comparisons, we should use Upper() or Lower() functions:

   if Upper(s1) = Upper(s2)
      see "The strings are equal"
   ok
