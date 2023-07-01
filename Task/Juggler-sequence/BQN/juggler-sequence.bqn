Juggle ← {
    Step ← ⌊⊢⋆(0.5 + 2|⊢)
    ¯1‿0‿0 + 3↑{
        n‿imax‿max‿term ← 𝕩
        𝕊⍟(term≠1) ⟨n+1, (max<term)⊑imax‿n, max⌈term, Step term⟩
    } 0‿0‿0‿𝕩
}

>⟨"NLIH"⟩ ∾ (⊢∾Juggle)¨ 20+↕20
