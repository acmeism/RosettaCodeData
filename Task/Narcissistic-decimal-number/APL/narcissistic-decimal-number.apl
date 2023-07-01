∇r ← digitsOf n;digitList
  digitList ← ⍬
loop:→((⌊n)=0)/done
  digitList ← digitList,(⌊n|⍨10)
  n ← n÷10
  →loop
done: r ← ⊖digitList
∇

∇r ← getASN n;idx;list
  idx ← 0
  list ← 0⍴0
loop:
  →(n=⍴list)/done
  →(isArmstrongNumber idx)/add
  →next
add:
  list ← list,idx
next:
  idx ← idx+1
  →loop
done:
  r ← list
∇

∇r ← isArmstrongNumber n;digits;nd
  digits ← digitsOf n  ⍝⍝ (⍎¨⍕n) is equivalent, but about 45% slower!!
  nd ← ≢ digits
  r ← n = +/digits * nd
∇

      getASN 25
0 1 2 3 4 5 6 7 8 9 153 370 371 407 1634 8208 9474 54748 92727 93084 548834 1741725 4210818 9800817 9926315
