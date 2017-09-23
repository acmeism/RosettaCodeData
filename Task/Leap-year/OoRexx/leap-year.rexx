::routine isLeapYear
  use arg year
  d = .datetime~new(year, 1, 1)
  return d~isLeapYear
