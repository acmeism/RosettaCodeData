Knuth ← {
  𝕊 arr:
  l ← ≠arr
  {
    arr ↩ ⌽⌾(⟨•rand.Range l, 𝕩⟩⊸⊏)arr
  }¨↕l
  arr
}
P ← •Show Knuth

P ⟨⟩
P ⟨10⟩
P ⟨10, 20⟩
P ⟨10, 20, 30⟩
