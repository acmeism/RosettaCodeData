|next isHappy happyNumbers|

next :=
    [:n |
        (n printString collect:[:ch | ch digitValue squared] as:Array) sum
    ].

isHappy :=
    [:n |  | t already |
        already := Set new.
        t := n.
        [ t == 1 or:[ (already includes:t)]] whileFalse:[
            already add:t.
            t := next value:t.
        ].
        t == 1
    ].

happyNumbers := OrderedCollection new.
try := 1.
[happyNumbers size < 8] whileTrue:[
      (isHappy value:try) ifTrue:[ happyNumbers add:try].
      try := try + 1
].
happyNumbers printCR
