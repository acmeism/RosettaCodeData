hashsz = 9973
len hashind$[] hashsz
len hashv$[] hashsz
#
func hstrind key$ .
   for c$ in strchars key$
      c = strcode c$
      h = bitxor c h
      h = bitand (h * 16777619) 0xffffffff
   .
   return h mod1 hashsz
.
func$ hget key$ .
   hi = hstrind key$
   repeat
      if hashind$[hi] = key$ : return hashv$[hi]
      until hashind$[hi] = ""
      hi = hi mod hashsz + 1
   .
   return ""
.
proc hset key$ val$ .
   hi = hstrind key$
   while hashind$[hi] <> "" and hashind$[hi] <> key$
      hi = hi mod hashsz + 1
   .
   hashind$[hi] = key$
   hashv$[hi] = val$
.
#
keys$[] = [ "Bob" "Alice" "Trudy" ]
vals$[] = [ "555-1234" "555-2323" "555-6666" ]
for i to len keys$[]
   hset keys$[i] vals$[i]
.
for i to len keys$[]
   print hget keys$[i]
.
