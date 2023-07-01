_modMul ← { n _𝕣: n|× }
MillerRabin ← {  𝕊n: 10𝕊n ; iter 𝕊 n: !2|n
  # n = 1 + d×2⋆s
  s ← 0 {𝕨 2⊸|◶⟨+⟜1𝕊2⌊∘÷˜⊢,⊣⟩ 𝕩} n-1
  d ← (n-1) ÷ 2⋆s

  # Arithmetic mod n
  Mul ← n _modMul
  Pow ← Mul{𝔽´𝔽˜⍟(/2|⌊∘÷⟜2⍟(↕1+·⌊2⋆⁼⊢)𝕩)𝕨}

  # Miller-Rabin test
  MR ← {
       1 =𝕩 ? 𝕨≠s ;
    (n-1)=𝕩 ? 0   ;
        𝕨≤1 ? 1   ;
    (𝕨-1) 𝕊 Mul˜𝕩
  }
  C ← { 𝕊a: s MR a Pow d }  # Is composite
  {0:1; C •rand.Range⌾(-⟜2) n ? 0; 𝕊𝕩-1} iter
}
