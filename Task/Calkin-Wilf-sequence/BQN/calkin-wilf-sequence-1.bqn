GCD ← {m 𝕊⍟(0<m←𝕨|𝕩) 𝕨}
_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
Sim ← { # Simplify a fraction
  x𝕊1: 𝕨‿1;
  0𝕊y: 0‿𝕩;
  ⌊𝕨‿𝕩 ÷ 𝕨 GCD 𝕩
}
Add ← { # Add two fractions
  0‿b 𝕊 𝕩: 𝕩;
  𝕨 𝕊 0‿y: 𝕨;
  a‿b 𝕊 x‿y:
  ((a×y)+x×b) Sim b×y
}
Next ← {n‿d: ⌽(2×⌊÷´n‿d)‿1 Add (d-n)‿d} # Next term
Cal ← {Next⍟𝕩 1‿1}

•Show Cal 1+↕20

•Show {
  cnt‿fr:
  ⟨cnt+1,Next fr⟩
} _while_ {
  cnt‿fr:
  fr ≢ 83116‿51639
} ⟨1,1‿1⟩
