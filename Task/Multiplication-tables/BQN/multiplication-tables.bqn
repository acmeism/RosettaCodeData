Table ← {
  m ← •Repr¨ ×⌜˜1+↕𝕩             # The numbers, formatted individually
  main ← ⟨                       # Bottom part: three sections
    >(-⌈10⋆⁼𝕩)↑¨⊏m               # Original numbers
    𝕩⥊'|'                        # Divider
    ∾˘(-1+⌈10⋆⁼𝕩×𝕩)↑¨(≤⌜˜↕𝕩)/¨m  # Multiplied numbers, padded and joined
  ⟩
  head ← ' '¨⌾⊑ ⊏¨ main          # Header: first row but with space left of |
  ∾ >⟨head, "-+-"⊣¨¨head, main⟩  # Header, divider, and main
}

•Out˘ Table 12
