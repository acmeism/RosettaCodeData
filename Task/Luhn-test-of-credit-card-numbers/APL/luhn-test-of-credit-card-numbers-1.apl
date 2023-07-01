LuhnTest←{
     digits←⍎¨⍵                       ⍝ Characters to digits
     doubled←2∘×@(⌽⍤~1 0⍴⍨≢)⊢digits   ⍝ Double every other digit
     partial←-∘9@(9∘<)⊢doubled        ⍝ Subtract 9 is equivalent to sum of digits for the domain 10≤x≤19
     0=10|+/partial                   ⍝ Valid if sum is a multiple of 10
 }
