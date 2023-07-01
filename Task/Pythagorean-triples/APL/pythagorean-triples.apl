⍝ Determine whether given list of integers has GCD = 1
primitive←∧/1=2∨/⊢
⍝ Filter list given as right operand by applying predicate given as left operand
filter←{⍵⌿⍨⍺⍺ ⍵}

⍝ Function pytriples finds all triples given a maximum perimeter
∇res←pytriples maxperimeter;sos;sqrt;cartprod;ascending;ab_max;c_max;a_b_pairs;sos_is_sq;add_c;perimeter_rule
 ⍝ Input parameter maxperimeter is the maximum perimeter
 ⍝ Sum of squares of given list of nrs
 sos←+/(×⍨⊢)
 ⍝ Square root
 sqrt←(÷2)*⍨⊢
 ⍝ (cartesian product) all possible pairs of integers
 ⍝ from 1 to ⍵
 cartprod←{,{⍺∘.,⍵}⍨⍳⍵}
 ⍝ Predicate: are values in given list ascending
 ⍝ Given e.g. pair a, b, c: is a ≤ b ≤ c?
 ascending←∧/2≤/⊢
 ab_max←⌊maxperimeter÷2
 c_max←⌈maxperimeter×sqrt 2
 ⍝ Selects from all a,b combinations (a<abmax, b<abmax)
 ⍝ only those pairs where a ≤ b.
 a_b_pairs←ascending filter¨cartprod(ab_max)
 ⍝ Predicate: is the sum of squares of a and b
 ⍝ itself a square? (does it occur in the squares list)
 sos_is_sq←{{⍵≠1+c_max}(×⍨⍳c_max)⍳sos¨⍵}
 ⍝ Given a pair a,b add corresponding c to form a triple
 add_c←{⍵,sqrt sos ⍵}
 ⍝ Predicate: sum of items less than or equal to max
 perimeter_rule←{maxperimeter≥+/⍵}
 res←perimeter_rule¨filter add_c¨sos_is_sq filter a_b_pairs
∇
