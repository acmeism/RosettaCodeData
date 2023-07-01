# Helpers
_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
ToNum ← {neg ← '-'=⊑𝕩 ⋄ (¯1⋆neg)×10⊸×⊸+˜´·⌽-⟜'0'neg↓𝕩}

Subleq ← {
  𝕊 memory:
  {
    𝕊 ip‿mem:
    {
      ¯1‿b‿·: ⟨ip+3, (@-˜•term.CharB@)⌾(b⊸⊑) mem⟩;
      a‿¯1‿·: •Out @+a⊑mem, ⟨ip+3, mem⟩;
      a‿b‿c : d ← b-○(⊑⟜mem)a, ⟨(0<d)⊑⟨c, ip+3⟩, d⌾(b⊸⊑) mem⟩
    } mem⊏˜ip+↕3
  }  _while_ {𝕊 ip‿mem: ip≥0} 0‿memory
}

Subleq ToNum¨•args
