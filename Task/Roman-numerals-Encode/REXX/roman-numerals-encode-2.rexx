-- 25 May 2026
include Setting
numeric digits 20

say 'ROMAN NUMERALS ENCODE'
say version
test='1990 2008 2026 1666 3888 3999 4000 5555 7777 9999',
     '1 20 300 4000 50000 600000 7000000 80000000 900000000',
     '100000000000000009 123000456000789009'
say
say Right('Decimal',23) 'Roman'
say
do i=1 to words(test)
   w=word(test,i)
   say Right(Commatize(w),23) Dec2rom(w)
end
exit

Dec2rom:
procedure
arg xx
-- Standard form with lookup table and vinculum using (deep) parenthesis
arab='1000 900 500 400 100 90 50 40 10 9 5 4 1'
roma='M CM D CD C XC L XL X IX V IV I'
-- Process 3-digit groups from right to left
po=-1; rr=''
do p1=0 while xx>0
-- Next group
   d3=xx//1000; xx=xx%1000; r=''
-- Convert group to ancient style (see Version 1)
   do i=1 to 13
      a=Word(arab,i)
      do while d3>=a
         r||=Word(Roma,i); d3-=a
      end
   end
-- Convert group to standard style and add parenthesis
   if r<>'' then do
      if Wordpos(r,'I II III')>0 & p1>0 then do
         r=Translate(r,'M','I'); p2=p1-1
      end
      else
         p2=p1
      if p2=po then
         rr=Copies('(',p2)||r||Substr(rr,po+1)
      else
         rr=Copies('(',p2)||r||Copies(')',p2)||rr
      po=p2
   end
end
return rr

-- Commatize Dec2rom(faster alternative)
include Math
