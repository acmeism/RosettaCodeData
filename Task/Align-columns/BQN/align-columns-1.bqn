Split ← (⊢-˜+`×¬)∘=⊔⊢
PadRow ← {
  w‿t𝕊𝕩: # t → type.
         # 0 → left
         # 1 → right
         # 2 → center
 pstyle←t⊑⟨{0‿𝕩},{𝕩‿0},{⟨⌊𝕩÷2,⌈𝕩÷2⟩}⟩
 𝕩{(⊣∾𝕨∾⊢)´(Pstyle 𝕩)/¨<w}¨(⌈´-⊢)≠¨𝕩
}
Align ← {{𝕨∾' '∾𝕩}´˘⍉" "‿𝕨⊸PadRow˘⍉>⟨""⟩‿0 PadRow '$' Split¨(@+10) Split 𝕩}

1 Align text
