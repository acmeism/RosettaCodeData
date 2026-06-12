end←⟨"are","ēre","ere","ire"⟩
eCnj←⟨
  ⟨"o","as","at","amus","atis","ant"⟩
  ⟨"eo","es","et","emus","etis","ent"⟩
  ⟨"o","is","it","imus","itis","unt"⟩
  ⟨"io","is","it","imus","itis","iunt"⟩
⟩
Conj←{(¯3↓𝕩)⊸∾¨eCnj⊑˜⊑end⊐<¯3↑𝕩}

•Show >⋈⟜Conj¨⟨"amare","vidēre","ducere","audire"⟩
