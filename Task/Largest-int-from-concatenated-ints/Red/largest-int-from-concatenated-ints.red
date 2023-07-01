Red []

foreach seq [[1 34 3 98 9 76 45 4] [54 546 548 60]] [
  print rejoin sort/compare seq function [a b] [ (rejoin [a b]) > rejoin [b a] ]
]
