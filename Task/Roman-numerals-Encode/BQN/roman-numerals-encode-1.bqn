⟨ToRoman⇐R⟩ ← {
  ds ← 1↓¨(¯1+`⊏⊸=)⊸⊔" I IV V IX X XL L XC C CD D CM M"
  vs ← 1e3∾˜ ⥊1‿4‿5‿9×⌜˜10⋆↕3
  R ⇐ {
    𝕨𝕊0: "";
    (⊑⟜ds∾·𝕊𝕩-⊑⟜vs) 1-˜⊑vs⍋𝕩
  }
}
