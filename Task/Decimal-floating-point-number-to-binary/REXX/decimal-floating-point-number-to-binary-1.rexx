-- 25 Apr 2026
include Setting

say 'DECIMAL FLOATING POINT NUMBER TO BINARY'
say version
say
call ToBinary 23.34375
call ToDecimal 1011.11101
call ToBinary 16*16
call ToBinary 256*256
call ToDecimal 1001001
call ToBinary 0
call ToBinary 0.001
call ToDecimal 0.001
call ToBinary 0.1
call ToDecimal 0.1
call ToBinary 1/3
call ToDecimal 1111.1111
exit

ToBinary:
arg xx
say xx 'decimal =>' D2n(xx,2) 'binary =>' N2d(D2n(xx,2),2) 'decimal'
return

ToDecimal:
arg xx
say xx 'binary =>' N2d(xx,2) 'decimal =>' D2n(N2d(xx,2),2) 'binary'
return

D2n:
-- Convert base 10 float to base n float
procedure
arg xx,bb
-- Prepare
aa=Base62(); ip=Trunc(xx); fp=Frac(xx)
-- Integer part
ir=''
do while ip>0
   ir=Substr(aa,ip//bb+1,1)ir; ip=ip%bb
end
if ir='' then
   ir=0
-- Fractional part
fr=''; c=0
do until fp=0 | c=30
   fp*=bb; fr||=Substr(aa,Trunc(fp)+1,1); fp=Frac(fp); c+=1
end
return ir'.'fr

N2d:
-- Convert base n float to base 10 float
procedure
parse arg xx,bb
-- Prepare
aa=Base62()
parse var xx ip'.'fp
if ip='' then
   ip=0
if fp='' then
   fp=0
rr=0
-- Integer part
p=1
do i=Length(ip) by -1 to 1
   a=Pos(Substr(ip,i,1),aa)-1; rr+=p*a; p*=bb
end i
-- Fractional part
p=1/bb
do i=1 to Length(fp)
   a=Pos(Substr(fp,i,1),aa)-1; rr+=p*a; p/=bb
end i
return rr

-- Base62 alphabet; D2n fully functional; N2d fully functional; Frac
include Math
