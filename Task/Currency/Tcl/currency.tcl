package require math::decimal
namespace import math::decimal::*

set hamburgerPrice [fromstr 5.50]
set milkshakePrice [fromstr 2.86]
set taxRate [/ [fromstr 7.65] [fromstr 100]]

set burgers 4000000000000000
set shakes 2
set net [+ [* [fromstr $burgers] $hamburgerPrice] [* [fromstr $shakes] $milkshakePrice]]
set tax [round_up [* $net $taxRate] 2]
set total [+ $net $tax]

puts "net=[tostr $net], tax=[tostr $tax], total=[tostr $total]"
