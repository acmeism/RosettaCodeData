Cat←{ 0⊸<◶⟨1, (𝕊-⟜1)×(¯2+4×⊢)÷1+⊢⟩ 𝕩 }
Fact ← ×´1+↕
Cat1 ← { # direct formula
  ⌊0.5 + (Fact 2×𝕩) ÷ (Fact 𝕩+1) × Fact 𝕩
}
Cat2 ← { # header based recursion
  0: 1;
  (𝕊 𝕩-1)×2×(1-˜2×𝕩)÷𝕩+1
}

Cat¨ ↕15
Cat1¨ ↕15
Cat2¨ ↕15
