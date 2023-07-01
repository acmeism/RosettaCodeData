csvstr ← ⟨"C1,C2,C3,C4,C5", "1,5,9,13,17", "2,6,10,14,18", "3,7,11,15,19", "4,8,12,16,20"⟩

Split ← (⊢-˜¬×+`)∘=⟜','⊸⊔
strdata ← >Split¨csvstr
intdata ← •BQN¨⌾(1⊸↓) strdata
sums ← ⟨"SUMS"⟩ ∾+´˘ 1↓ intdata
done ← sums ∾˜˘ intdata
