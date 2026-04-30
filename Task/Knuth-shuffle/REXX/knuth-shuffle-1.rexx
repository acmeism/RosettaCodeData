-- 31 Mar 2026
include Setting

say 'KNUTH SHUFFLE'
say version
say
call MakeSt 'stem.','N',52,'A'
call ShowSt 'stem.','a card deck...',,3
call ShuffleSt
call ShowSt 'stem.','shuffled!',,3
exit

ShuffleSt:
procedure expose stem.
-- Fisher-Yates shuffle cf Durstenfeld-Knuth
do i=stem.0 by -1 to 2
   j=Random(1,i); t=stem.i; stem.i=stem.j; stem.j=t
end i
return 0

-- ShowSt; ShuffleSt (generic); MakeSt
include Math
