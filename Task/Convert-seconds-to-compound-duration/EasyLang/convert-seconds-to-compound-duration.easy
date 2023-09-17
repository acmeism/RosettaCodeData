func$ split sec .
   divs[] = [ 60 60 24 7 ]
   n$[] = [ "sec" "min" "hr" "d" "wk" ]
   len r[] 5
   for i = 1 to 4
      r[i] = sec mod divs[i]
      sec = sec div divs[i]
   .
   r[5] = sec
   for i = 5 downto 1
      if r[i] <> 0
         if s$ <> ""
            s$ &= ", "
         .
         s$ &= r[i] & " " & n$[i]
      .
   .
   return s$
.
print split 7259
print split 86400
print split 6000000
