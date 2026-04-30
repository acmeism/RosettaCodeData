-- 3 Oct 2025
include Setting
signal off notready

say 'BASE64 DECODE DATA'
say version
say
call Task1 'TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu'
call Task1 'TWFu'
call Task1 'TWE='
call Task1 'TQ=='
call Task1 'YW55IGNhcm5hbCBwbGVhc3VyZS4='
call Task2
exit

Task1:
procedure
parse arg xx
say 'Encoded ' xx
say 'Original' Decode64(xx)
say
return

Task2:
procedure
in='favicon.dat'; out='favcopy.ico'
rr=Decode64(Charin(in,1,30000))
call Charout out,rr,1
return

Decode64:
procedure
parse arg xx
-- Alphabet
a='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
lx=Length(xx)
rr=''
-- Loop thru encoded characters
do i=1 to lx
   c=Substr(xx,i,1)
-- If padding, discard 2 bits
   if c='=' then do
      rr=Left(rr,Length(rr)-2)
      iterate i
   end
-- Find position in alphabet
   p=Pos(c,a)-1
-- Convert to bits and take last 6
   b=Right(0000||X2b(D2x(p)),6)
-- Append
   rr||=b
end
-- Convert to character
return X2c(B2x(rr))

include Abend
