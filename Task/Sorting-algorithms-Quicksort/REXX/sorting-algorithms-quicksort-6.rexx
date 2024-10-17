numeric digits 9
parse version version; say version Digits() 'digits'
arg n v
if n = '' then n = 10
if v = '' then v = 1
show = (n > 0); n = Abs(n)
say 'Quicksort: Timing Version' v 'for' n 'random numbers'
call Generate
if show then call ShowSave
select
   when v = 1 then do
      call Save2Stem
      call Time 'r'; call Qsort n; say 'Qsort' format(time('e'),3,3) 'seconds'
      if show then call ShowStem
   end
   when v = 2 then do
      call Time 'r'; call Save2Stack; say 'Save2Stack' format(time('e'),3,3) 'seconds'
      call Time 'r'; call Quicksort; say 'Quicksort ' format(time('e'),3,3) 'seconds'
      call Time 'r'; call Stack2Stem; say 'Stack2Stem' format(time('e'),3,3) 'seconds'
      if show then call ShowStem
   end
   when v = 3 then do
      call Save2Stem
      call Time 'r'; call Elegant; say 'Elegant' format(time('e'),3,3) 'seconds'
      if show then call ShowStem
   end
   when v = 4 then do
      call Save2Stem
      call Time 'r'; call Recursive 1 n; say 'Recursive' format(time('e'),3,3) 'seconds'
      if show then call ShowStem
   end
   when v = 5 then do
      call Save2Stem
      call Time 'r'; call Optimized; say 'Optimized' format(time('e'),3,3) 'seconds'
      if show then call ShowStem
   end
   otherwise nop
end
say
exit

Generate:
do x = 1 to n
   save.x = 10000*Random(0,9999)+Random(0,9999)
end
save.0 = n
return

ShowSave:
do x = 1 to 5
   say x save.x
end
do x = n-4 to n
   say x save.x
end
return

ShowStem:
do x = 1 to 5
   say x stem.x
end
do x = n-4 to n
   say x stem.x
end
return

Save2Stem:
do x = 0 to n
   stem.x = save.x
end
return

/* Sorting procedures follow, not shown here */
