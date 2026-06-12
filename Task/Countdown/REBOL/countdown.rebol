REBOL [
   Title: "CountDown"
   Date: 1-May-2008
]

target: 952
list: [ 3 6 25 50 75 100 ]

op: [+ - * /]
ad: func[x y][x + y]
sb: func[x y][x - y]
ml: func[x y][if error? try [return x * y][0]]
dv: func[x y][either (x // y) = 0 [x / y][0]]
calculs: func[x y][make block! [(ad x y) (sb x y) (ml x y) (dv x y)]]
nwlist: func[list j i res][sort append head remove at head remove at copy list j i res]

sol: function[list size][ol][
  for i 1 (size - 1) 1 [
    for j (i + 1) size 1 [
      ol: reduce calculs list/:j list/:i
      for k 1 4 1 [
        if any [(ol/:k = target) all [(ol/:k <> 0) (size > 1) (s: sol (nwlist list j i ol/:k) (size - 1))]] [
          return rejoin [list/:j op/:k list/:i "=" ol/:k newline s]
  ] ] ] ]
  return false
]

print rejoin [ceb list length? list]
