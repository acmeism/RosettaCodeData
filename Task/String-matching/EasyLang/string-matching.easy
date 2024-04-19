func starts s$ t$ .
   if substr s$ 1 len t$ = t$
      return 1
   .
   return 0
.
func ends s$ t$ .
   if substr s$ (len s$ - len t$ + 1) len t$ = t$
      return 1
   .
   return 0
.
func contains s$ t$ .
   return if strpos s$ t$ > 0
.
print starts "hello world" "he"
print ends "hello world" "rld"
print contains "hello world" "wor"
