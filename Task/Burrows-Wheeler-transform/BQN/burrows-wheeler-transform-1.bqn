stx←@+2
BWT ← { # Burrows-Wheeler Transform and its inverse as an invertible function
  𝕊: "Input contained STX"!⊑stx¬∘∊𝕩 ⋄ (⍋↓𝕩) ⊏ stx∾𝕩;
  𝕊⁼: 1↓(⊑˜⍟(↕≠𝕩)⟜⊑ ⍋)⊸⊏ 𝕩
}
