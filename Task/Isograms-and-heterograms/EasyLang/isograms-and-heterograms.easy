repeat
   s$ = input
   until s$ = ""
   if len s$ > 1 : w$[] &= s$
.
func[] letters w$ .
   len r[] 127
   for c$ in strchars w$
      h = strcode c$
      r[h] += 1
   .
   return r[]
.
func cmp a b a$ b$ .
   if a > b : return 1
   if a = b
      if len a$ > len b$ : return 1
      if len a$ = len b$ and strcmp a$ b$ < 0 : return 1
   .
   return 0
.
proc sort &d$[] &d[] .
   n = len d$[]
   for i = 1 to n - 1
      for j = i + 1 to n
         if cmp d[j] d[i] d$[j] d$[i] = 1
            swap d$[j] d$[i]
            swap d[j] d[i]
         .
      .
   .
.
proc isograms .
   for w$ in w$[]
      cnt[] = letters w$
      n = 0
      for i to 127
         if cnt[i] = 1 : break 1
         if cnt[i] > 0
            if n = 0
               n = cnt[i]
            elif cnt[i] <> n
               break 1
            .
         .
      .
      if i > 127
         r$[] &= w$
         n[] &= n
      .
   .
   sort r$[] n[]
   for w$ in r$[] : print w$
.
proc heterogram lng .
   for w$ in w$[]
      if len w$ > lng
         cnt[] = letters w$
         for i to 127
            if cnt[i] > 0 and cnt[i] <> 1 : break 1
         .
         if i > 127
            r$[] &= w$
            n[] &= 0
         .
      .
   .
   sort r$[] n[]
   for w$ in r$[] : print w$
.
isograms
print ""
heterogram 10
#
# the content of unixdict.txt
input_data
aaa
anna
beriberi
coco
ii
iii
ambidextrous
atmospheric
bluestocking
