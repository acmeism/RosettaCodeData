-- 1 Jun 2025
include Settings

say 'ARRAYS'
say version
say
say 'A simple array...'
do i = 1 to 100
   a.i=i*i
end
say 'Square of' 5 'is' a.5
say 'Square of' 55 'is' a.55
say
say 'Mimic indexing...'
say 'Square of' 5 'is' a(5)
say 'Square of' 55 'is' a(55)
say
say 'A default value...'
b. = 'Out of range'
do i = 1 to 100
   b.i=1/i
end
say 'Inverse of' 5 'is' b.5
say 'Inverse of' 55 'is' b.55
say 'Inverse of' 555 'is' b.555
say
say 'An other index range...'
do i = -100 to 100
   c.i=i*i*i
end
j=-55; say 'Cube of' j 'is' c.j
j=-5; say 'Cube of' j 'is' c.j
j=5; say 'Cube of' j 'is' c.j
j=55; say 'Cube of' j 'is' c.j
say
say 'A sparse array...'
d.='Not calculated'
do i = 2 by 2 to 100
   d.i=-i
end
say 'Negative of' 55 'is' d.55
say 'Negative of' 56 'is' d.56
say
say 'Special indices...'
e.cat='civet'; say 'e.cat =' e.cat
a1='dog'; e.a1='pitbull'
a2=a1; say 'e.'a2 '=' e.a2
a1='x.y.z'; e.a1='periods'
a2=a1; say 'e.'a2 '=' e.a2
a1='x y z'; e.a1='spaces'
a2=a1; say 'e.'a2 '=' e.a2
a1='└┴┬├─┼'; e.a1='specials'
a2=a1; say 'e.'a2 '=' e.a2
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

include Abend
