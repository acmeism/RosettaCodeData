n: 50
case [
  n < 10   [print "small number"]
  n < 100  [print "medium number"]
  n < 1000 [print "large number"]
  true     [print "none of these"]
]

medium number

;CASE/ALL Prints all that are true
n: 50
case/all [
  n < 10   [print "small number"]
  n < 100  [print "medium number"]
  n < 1000 [print "large number"]
  true     [print "none of these"]
]

medium number
large number
none of these
