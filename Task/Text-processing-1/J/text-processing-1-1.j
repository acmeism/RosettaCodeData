  load 'files'
  parseLine=: 10&({. ,&< (_99&".;._1)@:}.)  NB. custom parser
  summarize=: # , +/ , +/ % #               NB. count,sum,mean
  filter=: #~ 0&<                           NB. keep valid measurements

  'Dates dat'=: |: parseLine;._2 CR -.~ fread jpath '~temp/readings.txt'
  Vals=:  (+: i.24){"1 dat
  Flags=: (>: +: i.24){"1 dat
  DailySummary=: Vals summarize@filter"1 Flags
  RunLengths=: ([: #(;.1) 0 , }. *. }:) , 0 >: Flags
   ]MaxRun=: >./ RunLengths
589
   ]StartDates=: Dates {~ (>:@I.@e.&MaxRun (24 <.@%~ +/)@{. ]) RunLengths
1993-03-05
