-- 7 Jul 2026
include Setting
arg rows
if rows='' then
   rows=100
rows/=1

say 'MODE'
say version
say

say 'Prepare a integer array with' rows 'rows...'
call Random ,,12345
call MakeSt 'stem.',rows
if rows<=100 then
   call Showst 'stem.','Input',10,10
call Timer 'r','prepare'

say 'Find mode(s) by counting items in associated array...'
say 'Mode =' ModerandomSt('stem.')
call Timer 'r','on random array'

say 'Sort array...'
call SortSt 'stem.'
if rows<=100 then
   call Showst 'stem.','Input',10,10
call Timer 'r','quicksort'
say 'Find mode(s) by using Quicksort and scan array for dups...'
say 'Mode =' ModesortedSt('stem.')
call Timer 'r','on sorted array'

say 'Reproduce some other examples...'
v='10 9 8 7 6 5 4 3 2 1'                     ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='10 9 8 7 6 5 4 3 2 1 0 0 0 0 0.11'        ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='30 10 20 30 40 50 -100 4.7 -11e+2'        ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='30 10 20 30 40 50 -100 4.7 -11e+2 -11e+2' ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='1 8 6 0 1 9 4 6 1 9 9 9'                  ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='1 2 3 4 5 6 7 8 9 10 11'                  ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='8 8 8 2 2 2'                              ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='cat kat Cat emu emu Kat'                  ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='0 1 2 3 3 3 4 4 4 4 1 0'                  ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='2 7 1 8 2'                                ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='2 7 1 8 2 8'                              ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='3 1 4 1 5 9 7 6'                          ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='3 1 4 1 5 9 7 6 3'                        ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='1 3 6 6 6 6 7 7 12 12 17'                 ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
v='1 1 2 4 4'                                ;say 'Mode' Vect2form(v) '=' Vect2form(Mode(v))
exit

-- MakeSt ShowSt Timer ModerandomSt ModesortedSt Vect2form Mode
include Math
