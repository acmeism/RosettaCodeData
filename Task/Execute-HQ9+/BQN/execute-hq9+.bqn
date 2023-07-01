Pl ← {(𝕩≠1)/"s"}
Lwr ← +⟜(32×1="A["⊸⍋)
nn ← {(•Fmt 𝕨)∾" "∾𝕩}´¨∾{
  ⟨
    ⟨𝕩,"bottle"∾(Pl 𝕩)∾" of beer on the wall"⟩
    ⟨𝕩,"bottle"∾(Pl 𝕩)∾" of beer"⟩
    ⟨"Take one down, pass it around"⟩
    ⟨𝕩-1,"bottle"∾(Pl 𝕩-1)∾" of beer on the wall"⟩
  ⟩
}¨⌽1+↕99

HQ9 ← {
  out ← ⟨⟨"Hello, World!"⟩, ⟨𝕩⟩, nn⟩
  acc ← +´'+'=𝕩
  ∾out⊏˜3⊸≠⊸/"hq9"⊐Lwr 𝕩
}

•Out¨HQ9 •GetLine@
