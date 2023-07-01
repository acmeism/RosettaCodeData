⟨ToArabic⇐A⟩ ← {
  c ← "IVXLCDM"         # Characters
  v ← ⥊ (10⋆↕4) ×⌜ 1‿5  # Their values
  A ⇐ +´∘(⊢×¯1⋆<⟜«) v ⊏˜ c ⊐ ⊢
}
