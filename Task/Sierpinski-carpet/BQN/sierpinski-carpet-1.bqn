_decode ← {⌽𝕗|⌊∘÷⟜𝕗⍟(↕1+·⌊𝕗⋆⁼1⌈⊢)}
Carpet ← {  # 2D Array method using ∾.
  {∾(3‿3⥊4≠↕9)⊏⟨(≢𝕩)⥊0,𝕩⟩}⍟(𝕩-1) 1‿1⥊1
}
Carpet1 ← { # base conversion method, works in a single step.
  ¬{∨´𝕨∧○((-𝕨⌈○≠𝕩)⊸↑)𝕩}⌜˜2|3 _decode¨↕3⋆𝕩-1
}

•Show " #"⊏˜Carpet 4
•Show (Carpet ≡ Carpet1) 4
