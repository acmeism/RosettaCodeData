-- 21 Feb 2026
include Setting

say 'ARRAYS BASIC USAGE'
say version
say
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
call Showvars
exit

A:
procedure expose a.
arg xx
return a.xx

-- Showvars
include Math
