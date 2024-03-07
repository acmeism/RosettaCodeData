func mul32 a b .
   # to avoid overflow with 53bit integer precision with double
   ah = a div 0x10000
   al = a mod 0x10000
   bh = b div 0x10000
   bl = b mod 0x10000
   return al * bl + al * bh * 0x10000 + bl * ah * 0x10000
.
global state_bsd state_ms .
func rand_bsd .
   state_bsd = (mul32 1103515245 state_bsd + 12345) mod 0x80000000
   return state_bsd
.
func rand_ms .
   state_ms = (214013 * state_ms + 2531011) mod 0x80000000
   return state_ms div 0x10000
.
for i = 1 to 5
   print rand_bsd
.
print ""
for i = 1 to 5
   print rand_ms
.
