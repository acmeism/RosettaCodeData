 HappyNumbers←{          ⍝ return the first ⍵ Happy Numbers
     ⍺←⍬                 ⍝ initial list
     ⍵=+/⍺:⍸⍺            ⍝ 1's mark happy numbers
     sq←×⍨               ⍝ square function (times selfie)
     isHappy←{           ⍝ is ⍵ a happy number?
         ⍺←⍬             ⍝ previous sums
         ⍵=1:1           ⍝ if we get to 1, it's happy
         n←+/sq∘⍎¨⍕⍵     ⍝ sum of the square of the digits
         n∊⍺:0           ⍝ if we hit this sum before, it's not happy
         (⍺,n)∇ n}       ⍝ recurse until it's happy or not
     (⍺,isHappy 1+≢⍺)∇ ⍵ ⍝ recurse until we have ⍵ happy numbers
 }
      HappyNumbers 8
1 7 10 13 19 23 28 31
