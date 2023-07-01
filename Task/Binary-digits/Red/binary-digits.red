Red []

foreach number [5 50 9000] [
  ;; any returns first not false value, used to cut leading zeroes
  binstr: form any [find enbase/base to-binary number 2 "1" "0"]
  print reduce [ pad/left number 5 binstr ]
]
