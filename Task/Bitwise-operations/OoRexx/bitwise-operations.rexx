/* ooRexx *************************************************************
/ Bit Operations work as in Rexx (of course)
* Bit operations are performed up to the length of the shorter string.
* The rest of the longer string is copied to the result.
* ooRexx introduces the possibility to specify a padding character
* to be used for expanding the shorter string.
* 10.11.2012 Walter Pachl taken over from REXX and extended for ooRexx
**********************************************************************/
a=21
b=347
Say '          a :'c2b(a) '        'c2x(a)
Say '          b :'c2b(b)           c2x(b)
Say 'bitand(a,b) :'c2b(bitand(a,b)) c2x(bitand(a,b))
Say 'bitor(a,b)  :'c2b(bitor(a,b))  c2x(bitor(a,b))
Say 'bitxor(a,b) :'c2b(bitxor(a,b)) c2x(bitxor(a,b))
p='11111111'B
Say 'ooRexx only:'
Say 'a~bitor(b,p):'c2b(a~bitor(b,p)) c2x(a~bitor(b,p))
Exit
c2b: return x2b(c2x(arg(1)))
