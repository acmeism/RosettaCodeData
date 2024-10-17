b ← 10  # Base
m ← 20  # Maximum number of digits
S ← {(≡⟜∨¨/⊢)⟜((𝕨↑/⁼)¨) 𝕨↑¨𝕩}               # Get solutions from partitions 𝕩 of 𝕨
p ← ∾¨ ∾⟜(<-⟜↕∘≠{𝕨∾¨∾(-𝕨⌊≠𝕩)↑𝕩}¨⊢)⍟m ⋈⋈⋈↕0  # Partitions of 0...m
d ← ∾ 1 ↓ (↕≠p) S¨ (∧´¨b⊸>)⊸/¨ p            # Digits of self-describing numbers
b⊸×⊸+˜´∘⌽¨ d
