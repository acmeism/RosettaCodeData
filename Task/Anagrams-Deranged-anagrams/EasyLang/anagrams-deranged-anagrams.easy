proc norm s$ &name$[] &cnt[] &id .
   d$[] = strchars s$
   for i = 1 to len d$[] - 1
      for j = i + 1 to len d$[]
         if strcode d$[j] < strcode d$[i] : swap d$[j] d$[i]
      .
   .
   n$ = strjoin d$[] ""
   for id to len name$[] : if name$[id] = n$ : break 1
   if id > len name$[]
      name$[] &= n$
      cnt[] &= 0
   .
   cnt[id] += 1
.
func deranged a$ b$ .
   for i to len a$
      if substr a$ i 1 = substr b$ i 1 : return 0
   .
   return 1
.
global maxlng w$[] .
proc read .
   repeat
      s$ = input
      until s$ = ""
      w$[] &= s$
      maxlng = higher maxlng len s$
   .
.
read
#
len wid[] len w$[]
done = 0
proc search a b .
   for i = a to b
      norm w$[i] name$[] cnt[] id
      wid[i] = id
   .
   for id to len name$[] : if cnt[id] > 1
      h[] = [ ]
      for i = a to b : if wid[i] = id : h[] &= i
      for i to len h[] - 1 : for j = i + 1 to len h[]
         if deranged w$[h[i]] w$[h[j]] = 1
            print w$[h[i]] & " " & w$[h[j]]
            done = 1
         .
      .
   .
.
b = len w$[]
while done = 0 and maxlng >= 2
   a = b
   for i = b downto 1 : if len w$[i] = maxlng
      swap w$[i] w$[a]
      a -= 1
   .
   search a + 1 b
   maxlng -= 1
.
#
# a few lines of unixdict.txt, also works with all
input_data
ancestor
ancestral
ancestry
anchor
lana
lancashire
lancaster
lance
zucchini
zurich
zygote
