-- 15 May 2026
include Setting
numeric digits 4

say 'APPLY A CALLBACK TO AN ARRAY'
say version
say
say 'Generate...'
call Struct2stem 'stem.','1 2 3 4 5 6 7 8 9 10'
call ShowSt 'stem.','1 to 10 ascending',,7
call CopySt 'stem.','copy.'

say 'Single function Square'
call MapSt 'stem.','square'
call ShowSt 'stem.','after Square',,7

say 'Your own function Cube...'
call CopySt 'copy.','stem.'
call MapSt 'stem.','cube'
call ShowSt 'stem.','after Cube',,7

say 'Expression x^2+2x+3...'
call CopySt 'copy.','stem.'
call MapSt 'stem.','x**2+2*x+3'
call ShowSt 'stem.','after simple formula',,7

say 'Expression Sin(x)+Square(x)...'
call CopySt 'copy.','stem.'
call MapSt 'stem.','sin(x)+square(x)'
call ShowSt 'stem.','after more involved formula',,7
exit

Cube:
arg xx
return xx**3

-- MapSt Struct2stem ShowSt CopySt Square Sin
include Math
