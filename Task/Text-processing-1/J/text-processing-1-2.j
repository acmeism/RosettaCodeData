formatDailySumry=: dyad define
  labels=. , ];.2 'Line: Accept: Line_tot: Line_avg: '
  labels , x ,. 7j0 10j3 10j3 ": y
)
formatFileSumry=: dyad define
  labels=. ];.2 'Total: Readings: Average: '
  sumryvals=. (, %/) 1 0{ +/y
  out=. labels ,. 12j3 12j0 12j3 ":&> sumryvals
  'maxrun dates'=. x
  out=. out,LF,'Maximum run(s) of ',(": maxrun),' consecutive false readings ends at line(s) starting with date(s): ',dates
)
