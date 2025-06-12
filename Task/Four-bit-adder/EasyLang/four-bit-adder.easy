proc xor a b &r .
   na = bitand bitnot a 1
   nb = bitand bitnot b 1
   r = bitor bitand a nb bitand b na
.
proc half_add a b &s &c .
   xor a b s
   c = bitand a b
.
proc full_add a b c &s &g .
   half_add a c x y
   half_add x b s z
   g = bitor y z
.
proc bit4add a4 a3 a2 a1 b4 b3 b2 b1 &s4 &s3 &s2 &s1 &c .
   full_add a1 b1 0 s1 c
   full_add a2 b2 c s2 c
   full_add a3 b3 c s3 c
   full_add a4 b4 c s4 c
.
write "1101 + 1011 = "
bit4add 1 1 0 1 1 0 1 1 s4 s3 s2 s1 c
print c & s4 & s3 & s2 & s1
