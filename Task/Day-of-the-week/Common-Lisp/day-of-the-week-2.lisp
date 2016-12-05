(loop for year from 2008 upto 2121
   for xmas = (encode-universal-time 0 0 0 25 12 year)
   for day  = (nth-value 6 (decode-universal-time xmas))
   when (= day 6) collect year)
