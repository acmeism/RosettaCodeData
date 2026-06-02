-- 25 May 2026
include Setting
numeric digits 20
say 'ROMAN NUMERALS DECODE'
say version
test='MCMXL MMVIII MMXXVI MDCLXVI MMMDCCCLXXXVIII MMMCMXCIX',
     '(IV) (V)DLV (VII)DCCLXXVII (IX)CMXLIX',
     'I XX CCC (IV) (L) (DC) ((VII)) ((LXXX)) ((CM)) (((((C)))))IX',
     '(((((CXXIII)))))(((CDLVI)))(DCCLXXXIX)IX',
     'XXIIII LXXIIII CCCCLXXXX VIIII LXXXX DCCCC XLIIII',
     'IIII MDCCCCX MDCDIII XIIX IIIXX IIXX IIIC IIC IC'
say
say Right('Roman',40) 'Decimal'
say
do i=1 to Words(test)
   w=Word(test,i)
   say Right(w,40) Commatize(Rom2dec(w))
end
exit

Rom2dec:
procedure
arg xx
-- Standard form with lookup table and vinculum using (deep) parenthesis
Arab.m=1000; Arab.d=500; Arab.c=100; Arab.l=50; Arab.x=10; Arab.v=5; Arab.i=1; Arab.n=0
h=0; s=1; rr=0
do k=Length(xx) by -1 to 1
   r=Substr(xx,k,1)
   select
      when r='(' then
         s=1
      when r=')' then
         s*=1000
      otherwise do
         r=Arab.r*s
         if r>h then
            h=r
         if r<h then
            rr-=r
         else
            rr+=r
      end
   end
end k
return rr

-- Commatize Rom2dec(full version)
include Math
