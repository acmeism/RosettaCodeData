Red [
   title: "Bubble Sort"
   author: "hinjolicious"
   resources: "Red Sensei, etc."
]

bubble: function [a][
   n: length? a
   forever [
      if n <= 1 [return a]
      swapped: false
      repeat i n - 1 [
         if a/(i) > a/(i + 1) [
            swap  at a i  at a i + 1
            swapped: true
         ]
      ]
      unless swapped [return a]
      n: n - 1
   ]
   a
]

random/seed 1
max: 10000
dat: collect [loop max [keep random max]]

t: now/time/precise
bubble dat
print ["bubble: " now/time/precise - t]
print ["sorted: " dat]

