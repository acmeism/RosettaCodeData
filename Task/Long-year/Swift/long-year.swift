func isLongYear(_ year: Int) -> Bool {
  let year1 = year - 1
  let p = (year + (year / 4) - (year / 100) + (year / 400)) % 7
  let p1 = (year1 + (year1 / 4) - (year1 / 100) + (year1 / 400)) % 7

  return p == 4 || p1 == 3
}

for range in [1900...1999, 2000...2099, 2100...2199] {
  print("\(range): \(range.filter(isLongYear))")
}
