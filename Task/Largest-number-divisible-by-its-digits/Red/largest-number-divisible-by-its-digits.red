Red []
t0: now/time/precise    ;; measure runtime
lbn: 98764321 + 1       ;; because digit 5 is ruled out, this is the highest 8 digit number
                        ;; possible, add 1 because only even numbers are possible

check: func [tos [ string! ]] [               ;; function to check if number is divideable by
  foreach ele tos [                           ;; all of its digits
      div: to-integer  ele - #"0"             ;; convert asci digit to integer
      unless lbn % div = 0 [ return false ]   ;; fail at first false condition ( unless = if not...)
  ]
 true                                         ;; true if all digits passed
]

forever [
  lbn: lbn - 2                  ;; only even numbers could be possible results
  if find tos: to-string lbn  "0" [continue]  ;; no "0" allowed
  if find tos "5" [continue]                  ;; "5" also excluded
  unless tos = unique tos [ continue ]        ;; only unique digits allowed
  unless check tos [continue]                 ;; passed check ?
  print lbn                                   ;; first hit is result
  probe now/time/precise - t0                 ;; display runtime
  halt
]
