list ← ⟨6, 81, 243, 14, 25, 49, 123, 69, 11⟩

W_sort ← {{i←2↑∧𝕩, (𝕩/˜¬𝕩∊i)∾+´i}⍟(↕≠𝕩)𝕩}

WO_sort ← {{m←⌊´𝕩, n←⌊´𝕩/˜¬m=𝕩, (𝕩/˜¬𝕩∊m‿n)∾m+n}⍟(↕≠𝕩)𝕩}

•Show¨W_sort list
•Show¨WO_sort list
