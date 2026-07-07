-- 26 Jun 2026
include Setting
numeric digits 1000

say 'GIUGA NUMBERS'
say version
say
say 'Find first 4 Giuga numbers:'
do n=1 to 100000
   call Uf n
end
call Timer 'r'
say 'Verify Giuga numbers no 5 thru 12:'
call Uf 2214408306
call Uf 24423128562
call Uf 432749205173838
call Uf 14737133470010574
call Uf 550843391309130318
call Uf 244197000982499715087866346
call Uf 554079914617070801288578559178
call Uf 1910667181420507984555759916338506
call Timer 'r'
exit

Uf:
procedure expose Ufac. Glob.
arg n
nn=Ufactors(n)
if nn>1 then do
   do i=1 to nn until (n/f-1)//f<>0
      f=Ufac.i
   end
   if i>nn then
      say n 'is a Giuga number'
end
return

-- Timer UfactorS
include Math
