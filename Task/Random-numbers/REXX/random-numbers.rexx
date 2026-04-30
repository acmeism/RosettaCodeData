-- 25 Apr 2026
include Setting

say 'RANDOM NUMBERS'
say version
say
call GetUniform 1e3
call ShowFirst
call ShowStats
call ShowExact
call GetNormal 1e3
call ShowFirst
call ShowStats
call GetUniform 1e6
call ShowStats
call GetNormal 1e6
call ShowStats
call Timer
exit

GetUniform:
procedure expose Memo. Work.
arg xx
say 'Get' xx 'uniform distributed random numbers...'
Work. = 0
do n = 1 to xx
   Work.n = Rand12()
end
Work.0 = xx
say 'Done'
say
return

GetNormal:
procedure expose Memo. Work.
arg xx
say 'Get' xx 'normal(1,1/2) distributed random numbers...'
Work. = 0
do n = 1 to xx
   Work.n = Randn(1,0.5)
end
Work.0 = xx
say 'Done'
say
return

ShowFirst:
procedure expose Work.
say 'First 5 items...'
do i = 1 to 5
   call CharOut ,Work.i/1' '
end
say; say
return

ShowStats:
procedure expose Memo. Work.
say 'Statistics for' Work.0 'items...'
parse value StatsSt('Work.') with mean dev vari
say 'Average  ' mean
say 'Deviation' dev
say 'Variance ' vari
say
return

ShowExact:
procedure expose Memo.
say 'Exact statistics for infinite items...'
say 'Average  ' 1/2 '(1/2)'
say 'Deviation' Std(SqRt(1/12)) '(SqRt(1/12))'
say 'Variance ' 1/12 '(1/12)'
say
return

-- Rand12: Randn; StatsSt; Std; Sqrt; Timer
include Math
