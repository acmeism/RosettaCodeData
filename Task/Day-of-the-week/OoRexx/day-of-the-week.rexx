date = .datetime~new(2008, 12, 25)
lastdate = .datetime~new(2121, 12, 25)

resultList = .array~new -- our collector of years

-- date objects are directly comparable
loop while date <= lastdate
  if date~weekday == 7 then resultList~append(date~year)
  -- step to the next year
  date = date~addYears(1)
end

say "Christmas falls on Sunday in the years" resultList~toString("Line", ", ")
