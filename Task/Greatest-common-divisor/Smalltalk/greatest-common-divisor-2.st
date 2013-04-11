|gcd_iter|

gcd_iter := [ :a :b |
  |u v|
   u := a. v := b.
   [ v > 0 ]
     whileTrue: [ |t|
        t := u.
        u := v.
        v := t rem: v
     ].
   u abs
].

(gcd_iter value: 40902 value: 24140) printNl.
