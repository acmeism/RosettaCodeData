-- 8 Aug 2025
include Settings
signal off novalue

say 'CREATE AN TWO-DIMENSIONAL ARRAY AT RUNTIME'
say version
say
call CreateMult
call ShowMult 'Global'
call CreateAddi
call ShowAddi 'Global'
call CreateSubt
call ShowSubt 'Global'
exit

CreateMult:
procedure expose Mult.
arg xx
do i = 1 to 9
   do j = 1 to 9
      Mult.i.j=i*j
   end
end
return

ShowMult:
parse arg xx
say '   'xx 'multiplication table'
say '   'Copies('-',25)
say '   1  2  3  4  5  6  7  8  9'
say '   'Copies('-',25)
do i = 1 to 9
   call CharOut ,i
   do j = 1 to 9
      call CharOut ,Right(Mult.i.j,3)
   end
   say
end
say '   'Copies('-',25)
say
return

CreateAddi:
procedure
do i = 1 to 9
   do j = 1 to 9
      Addi.i.j=i+j
   end
end
call ShowAddi 'Local'
return

ShowAddi:
parse arg xx
say '   'xx 'addition table'
say '   'Copies('-',25)
say '   1  2  3  4  5  6  7  8  9'
say '   'Copies('-',25)
if DataType(Addi.1.1) = 'CHAR' then do
   call CharOut ,'   'Addi.1.1 Addi.2. Addi.3.3'...'
   say
end
else do
   do i = 1 to 9
      call CharOut ,i
      do j = 1 to 9
         call CharOut ,Right(Addi.i.j,3)
      end
      say
   end
end
say '   'Copies('-',25)
say
return

CreateSubt:
procedure expose Subt.
do i = 1 to 9
   do j = 1 to 9
      Subt.i.j=i-j
   end
end
call ShowSubt 'Global'
drop Subt.
return

ShowSubt:
parse arg xx
say '   'xx 'subtraction table'
say '   'Copies('-',25)
say '   1  2  3  4  5  6  7  8  9'
say '   'Copies('-',25)
if DataType(Subt.1.1) = 'CHAR' then do
   call CharOut ,'   'Subt.1.1 Subt.2. Subt.3.3'...'
   say
end
else do
   do i = 1 to 9
      call CharOut ,i
      do j = 1 to 9
         call CharOut ,Right(Subt.i.j,3)
      end
      say
   end
end
say '   'Copies('-',25)
say
return

include Abend
