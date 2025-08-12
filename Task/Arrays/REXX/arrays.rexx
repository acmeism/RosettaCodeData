-- 7 Aug 2025
include Settings

say 'ARRAYS'
say version
say
if Pos('Regina',version) > 0 then
   call Library
say 'Simple array...'
do i = 1 to 10
   a.i=i*i
end
say 'Square of' 3 'is' a.3
say 'Square of' 7 'is' a.7
say
say 'Mimic indexing...'
say 'Square of' 3 'is' a(3)
say 'Square of' 7 'is' a(7)
say
say 'A default value...'
b. = 'Out of range'
do i = 1 to 10
   b.i=1/i
end
say 'Inverse of' 3 'is' b.3
say 'Inverse of' 7 'is' b.7
say 'Inverse of' 11 'is' b.11
say
say 'Index zero...'
do i = 1 to 10
   c.i=i*i*i
end
c.0=10
j=0; say 'Number of rows is' c.j
j=3; say 'Cube of' j 'is' c.j
j=7; say 'Cube of' j 'is' c.j
say
say 'Sparse array...'
d.=0
do i = 3 by 3 to 9
   d.i=-i
end
say 'Negative of' 3 'is' d.3
say 'Negative of' 7 'is' d.7
say
say 'More dimensions...'
e.=0
do i = 1 to 3
  do j = 1 to 3
     e.i.j=i*j
  end
end
say '1x2 is' e.1.2
say '3x2 is' e.3.2
say
call SysDumpVariables
say
say 'Element has no value...'
signal off novalue
say 'f.notassigned =' f.notassigned
signal on novalue name Abend
say 'f.notassigned =' f.notassigned
exit

A:
procedure expose a.
arg xx
return a.xx

Library:
say 'Library...'
call RxFuncAdd 'SysLoadFuncs','RegUtil','SysLoadFuncs'
call SysLoadFuncs
say
return

include Abend
