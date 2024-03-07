for i = 1 to 100
   drawer[] &= i
   sampler[] &= i
.
subr shuffle_drawer
   for i = len drawer[] downto 2
      r = randint i
      swap drawer[r] drawer[i]
   .
.
subr play_random
   shuffle_drawer
   for prisoner = 1 to 100
      found = 0
      for i = 1 to 50
         r = randint (100 - i)
         card = drawer[sampler[r]]
         swap sampler[r] sampler[100 - i - 1]
         if card = prisoner
            found = 1
            break 1
         .
      .
      if found = 0
         break 1
      .
   .
.
subr play_optimal
   shuffle_drawer
   for prisoner = 1 to 100
      reveal = prisoner
      found = 0
      for i = 1 to 50
         card = drawer[reveal]
         if card = prisoner
            found = 1
            break 1
         .
         reveal = card
      .
      if found = 0
         break 1
      .
   .
.
n = 10000
win = 0
for _ = 1 to n
   play_random
   win += found
.
print "random: " & 100.0 * win / n & "%"
#
win = 0
for _ = 1 to n
   play_optimal
   win += found
.
print "optimal: " & 100.0 * win / n & "%"
