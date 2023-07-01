Red[]

; allowed characters
alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
; target string
target: "METHINKS IT IS LIKE A WEASEL"
; parameter controlling the number of children
C: 10
; parameter controlling the evolution rate
RATE: 0.05

; compute closeness of 'string' to 'target'
fitness: function [string] [
  sum: 0

  repeat i length? string [
    if not-equal? pick string i pick target i [
      sum: sum + 1
    ]
  ]

  sum
]

; return copy of 'string' with mutations, frequency based on given 'rate'
mutate: function [string rate] [
  result: copy string

  repeat i length? result [
    if rate > random 1.0 [
      poke result i random/only alphabet
    ]
  ]

  result
]

; create initial random parent
parent: ""
repeat i length? target [
  append parent random/only alphabet
]

; main loop, displaying progress
while [not-equal? parent target] [
  print parent
  children: copy []

  repeat i C [
    append children mutate parent RATE
  ]
  sort/compare children function [a b] [lesser? fitness a fitness b]

  parent: pick children 1
]
print parent
