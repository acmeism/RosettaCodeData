⍝⍝ APL2 'tradfn' (traditional function)
⍝⍝ This syntax works in all dialects including GNU APL and Dyalog.
∇ product ← a multiply b
  product ← a × b
∇

      ⍝⍝ A 'dfn' or 'lambda' (anonymous function)
      multiply ← {⍺×⍵}
