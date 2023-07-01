Move ← {
    𝕩⊑⊸≤0 ? ⟨⟩;
    𝕊 n‿from‿to‿via:
    l ← 𝕊 ⟨n-1, from, via, to⟩
    r ← 𝕊 ⟨n-1, via, to, from⟩
    l∾(<from‿to)∾r
}
{"Move disk from pole "∾(•Fmt 𝕨)∾" to pole "∾•Fmt 𝕩}´˘>Move 4‿1‿2‿3
