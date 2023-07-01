funsA ← ⟨⋆⟜2,-,•math.Sin,{𝕩×3}⟩
funsB ← ⟨√,-,•math.Asin,{𝕩÷3}⟩

comp ← funsA {𝕎∘𝕏}¨ funsB

•Show comp {𝕎𝕩}¨<0.5
