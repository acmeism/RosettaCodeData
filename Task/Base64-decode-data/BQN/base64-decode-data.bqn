m ← ⌽64⋆↕4
d ← ⌽÷256⋆↕3
Decode ← 256|·⌊d×·+´m×⊢
sym ← ∾ "Aa0+/" +⟜↕¨ 26‿26‿10‿1‿1
B64Dec ← @+·(⌊0.75×≠)⊸⥊⟜(Decode˘↑‿4⥊⊢)64(>/⊢)sym⊐⊢

B64Dec "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g="
