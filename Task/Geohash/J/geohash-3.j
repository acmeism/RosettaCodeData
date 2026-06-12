hsahoeg=: {{
   bits=: |.|:0,~_2]\,(5#2)#:gdigits i.y
   scale=: %2^{:$bits
   lo=: scale*#.bits
   hi=: scale*(2^1+1 0*2|#y)+#.bits
   0.5*_180+360*lo,.hi
}}
