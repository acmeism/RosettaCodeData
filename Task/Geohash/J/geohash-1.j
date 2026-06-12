gdigits=: '0123456789bcdefghjkmnpqrstuvwxyz'

geohash=: {{
  bits=. 3*x
  x{.gdigits{~_5 #.\,|:|.(bits#2)#:<.(2^bits)*(y+90 180)%180 360
}}
