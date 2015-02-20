set iban "GB82 WEST 1234 5698 7654 32"
puts "$iban is [expr {[verifyIBAN $iban] ? {verified} : {unverified}}]"
set not "GB42 WEST 1234 5698 7654 32"
puts "$not is [expr {[verifyIBAN $not] ? {verified} : {unverified}}]"
