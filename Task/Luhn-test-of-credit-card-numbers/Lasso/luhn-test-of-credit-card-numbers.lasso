#!/usr/bin/lasso9

define luhn_check(number) => {
  local(
    rev = #number->asString,
    checksum = 0
  )
  #rev->reverse
  iterate(#rev, local(digit)) => {
    if((loop_count % 2) == 0) => {
      #checksum += (2 * integer(#digit))
      integer(#digit) >= 5 ? #checksum -= 9
    else
      #checksum += integer(#digit)
    }
  }
  (#checksum % 10) != 0 ? return false
  return true
}

stdoutnl(luhn_check(49927398716))       // true
stdoutnl(luhn_check(49927398717))       // false
stdoutnl(luhn_check(1234567812345678))  // false
stdoutnl(luhn_check(1234567812345670))  // true
