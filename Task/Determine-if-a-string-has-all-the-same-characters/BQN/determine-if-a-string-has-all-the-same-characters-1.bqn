Check←=´˘2⊸↕
Hex←⊏⟜(∾"0A"+⟜↕¨10‿26)16{⌽𝕗|⌊∘÷⟜𝕗⍟(↕1+·⌊𝕗⋆⁼1⌈⊢)}

{
  𝕊 str:
  r←Check 2⊸↑⍟(0=≠)str
  •Out {
    ∧´r ? "All characters are the same" ;
    i←⊑r⊐0
    ch←(i+1)⊑str
    "'"∾ch∾"' (hex: "∾(Hex ch-@)∾", index: "∾(•Fmt i)∾") mismatched in string '"∾str∾"'"
  }
}¨⟨
  ""
  "   "
  "2"
  "333"
  ".55"
  "tttTTT"
  "4444   444k"
⟩
