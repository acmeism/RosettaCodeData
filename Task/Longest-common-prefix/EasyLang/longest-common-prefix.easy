func$ lcp list$[] .
   if len list$[] = 0
      return ""
   .
   shortest$ = list$[1]
   for s$ in list$[]
      if len s$ < len shortest$
         shortest$ = s$
      .
   .
   for i to len shortest$ - 1
      sub$ = substr shortest$ 1 i
      for s$ in list$[]
         if substr s$ 1 i <> sub$
            return substr shortest$ 1 (i - 1)
         .
      .
   .
   return shortest$
.
print lcp [ "interspecies" "interstellar" "interstate" ]
print lcp [ "throne" "throne" ]
print lcp [ "throne" "dungeon" ]
print lcp [ "throne" "" "throne" ]
print lcp [ "cheese" ]
print lcp [ ]
print lcp [ "foo" "foobar" ]
