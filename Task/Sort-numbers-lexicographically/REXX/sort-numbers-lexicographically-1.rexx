-- 13 Jun 2026
include Setting

say 'SORT NUMBERS LEXICOGRAPHICALLY'
say version
say
items=10; cols=5
call MakeSt 'Stem.','N',100
call Showst 'Stem.','Before',items,cols
call Sort10num
call Showst 'Stem.','After num sort',items,cols
call Sort10lex
call Showst 'Stem.','After lex sort',items,cols
exit

-- Sort10num uses standard compares
include SortSt func?=num stem?=Stem.
-- Sort10lex uses strict compares
include SortSt func?=lex stem?=Stem. lt?=<< eq?=== gt?=>>
-- MakeSt, ShowSt
include Math
