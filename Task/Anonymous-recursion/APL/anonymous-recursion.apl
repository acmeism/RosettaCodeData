fib←{               ⍝ Outer function
   ⍵<0:⎕SIGNAL 11   ⍝ DOMAIN ERROR if argument < 0
   {                ⍝ Inner (anonymous) function
      ⍵<2:⍵
      (∇⍵-1)+∇⍵-2   ⍝ ∇ = anonymous recursive call
   }⍵               ⍝ Call function in place
}
