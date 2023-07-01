PopCount ← {(2|𝕩)+𝕊⍟×⌊𝕩÷2}
Odious ← 2|PopCount
Evil ← ¬Odious

_List ← {𝕩↑𝔽¨⊸/↕2×𝕩}
>⟨PopCount¨ 3⋆↕30,
  Evil _List 30,
  Odious _List 30⟩
