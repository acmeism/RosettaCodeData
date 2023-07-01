task=: {{
  r=. ''
  days=. todayno 2020 02 02
  while. 15 > #r do.
    days=. ({:days)+1+i.1e4
    r=. r, days#~(-:|.)"1":,.1 todate days
  end.
  15 10{.isotimestamp todate r
}}
