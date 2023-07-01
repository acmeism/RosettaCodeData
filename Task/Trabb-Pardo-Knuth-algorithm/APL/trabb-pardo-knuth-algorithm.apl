∇ {res}←Trabb;f;S;i;a;y              ⍝ define a function Trabb
  f←{(0.5*⍨|⍵)+5×⍵*3}                ⍝ define a function f
  S←,⍎{⍞←⍵ ⋄ (≢⍵)↓⍞}'Please, enter 11 numbers: '
  :For i a :InEach (⌽⍳≢S)(⌽S)        ⍝ loop through N..1 and reversed S
      :If 400<y←f(a)
          ⎕←'Too large: ',⍕i
      :Else
          ⎕←i,y
      :EndIf
  :EndFor
∇
