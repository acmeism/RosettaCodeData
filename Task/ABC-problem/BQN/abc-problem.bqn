ABC ← {
   Matches ← ⊑⊸(⊑∘∊¨)˜ /⊣            # blocks matching current letter
   Others  ← <˘∘⍉∘(»⊸≥∨`)∘(≡⌜)/¨<∘⊣ # blocks without current matches
   𝕨(×∘≠∘⊢ ◶ ⟨1˙,                   # if the word is empty, it can be made
       Matches(×∘≠∘⊣ ◶ ⟨0˙,         # if no matching blocks, it cannot
           ∨´(𝕨 Others⊣) 𝕊¨ 1<∘↓⊢   # otherwise, remove block and try remaining letters
       ⟩)⊢
   ⟩) (⊢-32×1="a{"⍋⊢)𝕩
}

blocks←⟨"BO","XK","DQ","CP","NA","GT","RE","TG","QD","FS",
        "JW","HU","VI","AN","OB","ER","FS","LY","PC","ZM"⟩

words←⟨"A","bark","BOOK","TrEaT","Common","Squad","Confuse"⟩

> {(<𝕩) ∾ blocks ABC 𝕩}¨ words
