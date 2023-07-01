Red []

digits: charset [#"1" - #"9"]         ;; bitset for parse rule in valid function

check: function [s i ][                 ;; returns string with bulls -B and cows - C found
  return sort append copy "" collect [
    repeat pos 4 [ either ( v: pick i pos ) =  pick s pos [ keep "B"][ if find s v [keep "C"] ] ]
  ]
]

valid: function [ i] [ all [ parse i [4 digits]  ","  4 = length? unique i ] ]  ;; check if number/string is valid
                                                                             ;; collect all possible permutations
possible: collect [ repeat i 9876 [ if valid s: to-string i  [ keep s ] ] ]  ;; should start at 1234, but for sake of brevity...

forever [                                                                    ;; read valid secret number from keyboard...
	while [ not valid secret: ask "^/Enter Number with 4 uniq digits (1 - 9 only, q-quit ) " ] [  ;; "^/" is character for newline
	      either secret = "q" [print "Bye" halt ] [ print [ secret "invalid, Try again !" ]   ]
  ]

  results: copy #()                                          ;; map (key-value ) to store each guess and its result

  foreach guess possible [
    foreach [k v] body-of results [                          ;; check guess against previous results
      if  v <> check guess k  [ guess: copy "" break  ]	
    ]
    if  empty? guess [ continue ]                            ;; check against previous results failed ?
    put results guess res: check guess secret                ;; store current guess and result in map
    if res = "BBBB" [break]                                  ;; number found  ? then break foreach loop
  ]
  foreach [k v] body-of results [ print [k "-" v]]           ;; display all guesses and their results
  print [CR "Found *" last k: keys-of results "* in " length? k " attempts" CR]     ;; cr - constant for newline / carriage return
] ;; forever loop
