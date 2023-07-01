      s ← 'Mary had a ∆ lamb' ⋄ s[s⍳'∆'] ← ⊂'little' ⋄ s ← ∊s
      s
Mary had a little lamb

⍝⍝⍝ Or, for a more general version which interpolates multiple positional arguments and can
⍝⍝⍝ handle both string and numeric types...

∇r ← s sInterp sv
⍝⍝ Interpolate items in sv into s (string field substitution)
⍝ s: string - format string, '∆' used for interpolation points
⍝ sv: vector - vector of items to interpolate into s
⍝ r: interpolated string
  s[('∆'=s)/⍳⍴s] ← ⊃¨(⍕¨sv)
  r ← ∊s
∇
      'Mary had a ∆ lamb, its fleece was ∆ as ∆.' sInterp 'little' 'black' 'night'
Mary had a little lamb, its fleece was black as night.
      'Mary had a ∆ lamb, its fleece was ∆ as ∆.' sInterp 'little' 'large' 42
Mary had a little lamb, its fleece was large as 42.
