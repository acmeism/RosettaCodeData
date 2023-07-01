# Compute n|𝕨×𝕩 in high precision
_modMul ← { n _𝕣:
  # Split each argument into two 26-bit numbers, with the remaining
  # mantissa bit encoded in the sign of the lower-order part.
  q←1+2⋆27
  Split ← { h←(q×𝕩)(⊣--)𝕩 ⋄ ⟨𝕩-h,h⟩ }
  # The product, and an error relative to precise split multiplication.
  Mul ← × (⊣ ⋈ -⊸(+´)) ·⥊×⌜○Split
  ((n×<⟜0)⊸+ -⟜n+⊢)´ n | Mul
}
