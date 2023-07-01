Red []

;;-------------------------------------
count-dig: func ["count occurence of digit in number"
;;-------------------------------------
  s [string!] "number as string"
  sdig [char!] "search number as char"
][
cnt: #"0" ;; counter as char for performance optimization

while [s: find/tail s sdig][cnt: cnt + 1]
return cnt
]

;;-------------------------------------
isSDN?: func ["test if number is self describing number"
  s [string!] "number to test as string "
  ][
;;-------------------------------------

ind: #"0" ;; use digit as char for performance optimization

foreach ele s [
  if ele <> count-dig s ind [return false]
  ind: ind + 1
]
return true
]

repeat i 4000000 [  if isSDN? to-string i [print i] ]
