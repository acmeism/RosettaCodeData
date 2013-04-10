december = 11 # gotta love Date APIs :)
sunday = 0
for year in [2008..2121]
  xmas = new Date year, december, 25
  console.log year if xmas.getDay() is sunday
