'names numbers'=:|:".;._2]0 :0
  'map';                      9       150        1
  'compass';                 13        35        1
  'water';                  153       200        2
  'sandwich';                50        60        2
  'glucose';                 15        60        2
  'tin';                     68        45        3
  'banana';                  27        60        3
  'apple';                   39        40        3
  'cheese';                  23        30        1
  'beer';                    52        10        3
  'suntan cream';            11        70        1
  'camera';                  32        30        1
  'T-shirt';                 24        15        2
  'trousers';                48        10        2
  'umbrella';                73        40        1
  'waterproof trousers';     42        70        1
  'waterproof overclothes';  43        75        1
  'note-case';               22        80        1
  'sunglasses';               7        20        1
  'towel';                   18        12        2
  'socks';                    4        50        1
  'book';                    30        10        2
)

'weights values pieces'=:|:numbers
decode=: (pieces+1)&#:

pickBest=:4 :0
  NB. given a list of options, return the best option(s)
  n=. decode y
  weight=. n+/ .*weights
  value=.  (x >: weight) * n+/ .*values
  (value = >./value)#y
)

bestCombo=:3 :0
   limit=. */pieces+1
   i=. 0
   step=. 1e6
   best=. ''
   while.i<limit do.
      best=. 400 pickBest best,(#~ limit&>)i+i.step
      i=. i+step
   end.
   best
)

   bestCombo''
978832641
