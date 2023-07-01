Double ← 2⊸×
Halve ← ⌊÷⟜2
Odd ← 2⊸|

EMul ← {
  times ← ↕⌈2⋆⁼𝕨
  +´(Odd Halve⍟times 𝕨)/Double⍟times 𝕩
}

17 EMul 34
