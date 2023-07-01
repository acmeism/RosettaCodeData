list ← ⟨"Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Boz", "Zag"⟩

IndexOf ← {
  ("Error: '" ∾𝕩∾ "' Not found in list") ! (≠𝕨)≠ind ← ⊑𝕨⊐⋈𝕩
  ind
}

•Show list ⊐ "Wally"‿"Hi" # intended
•Show list IndexOf "Wally"
list IndexOf "Hi"
