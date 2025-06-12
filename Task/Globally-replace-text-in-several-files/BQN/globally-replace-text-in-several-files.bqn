#!/usr/bin/env bqn

_onfile ← {𝕩 •FChars (𝕨 𝔽 •FChars⎊"" 𝕩)}

FindReplace ← {(⊣-⊸⌽(1⊑𝕨)∾(≠⊑𝕨)↓⊣⌽⊢)´𝕩∾⟜<˜/(⊑𝕨)⍷𝕩}

files ← •wdpath⊸•file.At¨ •args

"Goodbye London!"‿"Hello New York!"⊸(FindReplace _onfile)¨ files
