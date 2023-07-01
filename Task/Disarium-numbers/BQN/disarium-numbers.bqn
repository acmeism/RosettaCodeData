Digits        ← {𝕊 0: ⟨⟩; (𝕊⌊𝕩÷10)∾10|𝕩}
DigitPowerSum ← (+´⊢⋆1+↕∘≠)∘Digits
Disarium      ← ⊢=DigitPowerSum

Disarium¨⊸/ ↕2500
