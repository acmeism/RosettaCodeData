#!/usr/bin/env bqn

# Cut 𝕩 at occurrences of 𝕨, removing separators and empty segments
# (BQNcrate phrase).
Split ← (¬-˜⊢×·+`»⊸>)∘≠⊔⊢

# Natural number from base-10 digits (BQNcrate phrase).
Base10 ← 10⊸×⊸+˜´∘⌽

# Parse any number of space-separated numbers from string 𝕩.
ParseNums ← {Base10¨ -⟜'0' ' ' Split 𝕩}

# •GetLine is a nonstandard CBQN extension.
•Show ⥊⟜(↕×´) ParseNums •GetLine@
