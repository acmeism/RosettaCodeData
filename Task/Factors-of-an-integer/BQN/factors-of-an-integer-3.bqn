⟨FactorExponents⟩ ← •Import "primes.bqn"  # With appropriate path
Factors ← { ∧⥊ 1 ×⌜´ ⋆⟜(↕1+⊢)¨˝ FactorExponents 𝕩 }
