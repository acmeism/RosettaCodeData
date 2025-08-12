-- 28 Jul 2025
include Settings

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
say 'Get' xx 'uniform distributed Random numbers...'
Work. = 0
do n = 1 to xx
   Work.n = Randu()
end
Work.0 = xx
say 'Done'
say
return

GetNormal:
procedure expose Memo. Work.
arg xx
say 'Get' xx 'normal(1,1/2) distributed Random numbers...'
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
sum = 0
do n = 1 to Work.0
   sum = sum+Work.n
end
avg = sum/Work.0
sum = 0
do n = 1 to Work.0
   sum = sum+(Work.n-avg)**2
end
varia = sum/Work.0; stdev = SqRt(varia)/1
say 'Average  ' Std(avg)
say 'Deviation' Std(stdev)
say 'Variance ' Std(varia)
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

include Math
