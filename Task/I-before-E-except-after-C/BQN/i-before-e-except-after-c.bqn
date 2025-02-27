Func ← {
  Filter ← {+´(∨´∘(𝕨⊸⍷))¨𝕩}
  nei ← "ei"  Filter 𝕩
  cei ← "cei" Filter 𝕩
  nie ← "ie"  Filter 𝕩
  cie ← "cie" Filter 𝕩
  •Show (nie < 2×cie)◶⟨
    "I before E when not preceded by C is plausible"
    "I before E when not preceded by C is not plausible"
  ⟩@
  (nei > 2×cei)◶⟨
    "E before I when preceded by C is plausible"
    "E before I when preceded by C is not plausible"
  ⟩@
}
