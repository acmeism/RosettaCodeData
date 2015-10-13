NB. pad the edges of an array with border pixels
NB. (increasing the first two dimensions by 1 less than the kernel size)
pad=: adverb define
  'a b'=. (<. ,. >.) 0.5 0.5 p. $m
  a"_`(0 , ] - 1:)`(# 1:)}~&# # b"_`(0 , ] - 1:)`(# 1:)}~&(1 { $) #"1 ]
)

kernel_filter=: adverb define
   ($m)+/ .*&(,m)&(,/);._3 m pad
)
