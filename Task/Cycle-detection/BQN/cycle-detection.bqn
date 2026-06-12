_Brent← {F _𝕣 x0:
  p←l←1
  (I ← {p=l?
    l↩1 ⋄ p×↩2 ⋄ 𝕩I𝕩 ;
    l+↩1 ⋄ 𝕨I𝕩
  }⍟≠⟜F) x0
  m←0
  {m+↩1 ⋄ 𝕨𝕊⍟≠○F𝕩}⟜(F⍟l) x0
  l‿m‿(F⍟(m+↕l)x0)
}
