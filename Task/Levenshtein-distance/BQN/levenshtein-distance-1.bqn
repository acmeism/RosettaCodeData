Levenshtein ← {
  𝕨 𝕊"": ≠𝕨;
  ""𝕊 𝕩: ≠𝕩;
  𝕨 𝕊 𝕩:
    Tail←1⊸↓
    𝕨 =○⊑◶⟨1+·⌊´ 𝕊○Tail ∾ Tail⊸𝕊 ∾ 𝕊⟜Tail, 𝕊○Tail⟩ 𝕩
}
