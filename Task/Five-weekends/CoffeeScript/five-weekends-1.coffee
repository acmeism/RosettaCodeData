startsOnFriday = (month, year) ->
  # 0 is Sunday, 1 is Monday, ... 5 is Friday, 6 is Saturday
  new Date(year, month, 1).getDay() == 5

has31Days = (month, year) ->
  new Date(year, month, 31).getDate() == 31

checkMonths = (year) ->
  month = undefined
  count = 0
  month = 0
  while month < 12
    if startsOnFriday(month, year) and has31Days(month, year)
      count += 1
      console.log year + ' ' + month + ''
    month += 1
  count

fiveWeekends = ->
  startYear = 1900
  endYear = 2100
  year = undefined
  monthTotal = 0
  yearsWithoutFiveWeekends = []
  total = 0
  year = startYear
  while year <= endYear
    monthTotal = checkMonths(year)
    total += monthTotal
    # extra credit
    if monthTotal == 0
      yearsWithoutFiveWeekends.push year
    year += 1
  console.log 'Total number of months: ' + total + ''
  console.log ''
  console.log yearsWithoutFiveWeekends + ''
  console.log 'Years with no five-weekend months: ' + yearsWithoutFiveWeekends.length + ''
  return

fiveWeekends()
