chars ← ⥊ "AaNn" +⌜ ↕13

Rot13 ← {𝕨 ⊣⌾((𝕩=52)⊸/) ⊏⟜chars 52|26+𝕩}⟜(chars⊸⊐)
