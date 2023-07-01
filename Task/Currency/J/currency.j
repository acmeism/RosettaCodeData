require 'format/printf'

Items=:    ;:    'Hamburger     Milkshake'
Quantities=:   4000000000000000      2
Prices=:   x:        5.50          2.86
Tax_rate=: x:  0.0765

makeBill=: verb define
  'items prices quantities'=. y
  values=. prices * quantities
  subtotal=. +/ values
  tax=. Tax_rate * subtotal
  total=. subtotal + tax

  '%9s %8s %20s %22s' printf ;:'Item Price Quantity Value'
  '%9s %8.2f %20d %22.2f' printf"1 items ,. <"0 prices ,. quantities ,. values
  '%62s' printf <'-------------------------------'
  '%40s %21.2f' printf"1 (;:'Subtotal: Tax: Total:') ,. subtotal;tax;total
)

makeBill Items;Prices;Quantities
