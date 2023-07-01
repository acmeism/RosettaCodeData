Check←=⌜˜
Hex←⊏⟜(∾"0A"+⟜↕¨10‿26)16{⌽𝕗|⌊∘÷⟜𝕗⍟(↕1+·⌊𝕗⋆⁼1⌈⊢)}

{
  𝕊 str:
  r←Check str
  •Out {
    ∧´1=+´˘r ? "All characters are unique" ;
    i←/⊏(1<+´˘r)/r
    ch←(⊑i)⊑str
    "'"∾ch∾"' (hex: "∾(Hex ch-@)∾", indices: "∾(•Fmt i)∾") duplicated in string '"∾str∾"'"
  }
}¨⟨
  ""
  "."
  "abcABC"
  "XYZ  ZYX"
  "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"
⟩
