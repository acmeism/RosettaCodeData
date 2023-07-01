FACTORS_h_=: p: i. 4
HUMBLE_h_=: 1
next_h_=: 3 : 0
 result=. <./ HUMBLE
 i=. HUMBLE i. result
 HUMBLE=: ~. (((i&{.) , (>:i)&}.) HUMBLE) , result * FACTORS
 result
)
reset_h_=: 3 :'0 $ HUMBLE=: 1'
