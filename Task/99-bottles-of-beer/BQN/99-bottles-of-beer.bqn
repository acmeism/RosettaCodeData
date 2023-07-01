Pl ← {(𝕩≠1)/"s"}
{𝕨∾(@+10)∾𝕩}´{(•Fmt 𝕨)∾" "∾𝕩}´¨∾{
  ⟨
    ⟨𝕩,"bottle"∾(Pl 𝕩)∾" of beer on the wall"⟩
    ⟨𝕩,"bottle"∾(Pl 𝕩)∾" of beer"⟩
    ⟨"Take one down, pass it around"⟩
    ⟨𝕩-1,"bottle"∾(Pl 𝕩-1)∾" of beer on the wall"∾@+10⟩
  ⟩
}¨⌽1+↕99
