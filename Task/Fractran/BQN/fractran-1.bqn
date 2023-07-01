# Fractran interpreter

# Helpers
_while_ ← {𝔽⍟𝔾∘𝔽_𝕣_𝔾∘𝔽⍟𝔾𝕩}
ToInt ← 10⊸×⊸+˜´·⌽-⟜'0'
ToFrac ← {
  i ← ⊑/'/'=𝕩
  ToInt¨i(↑⋈1⊸+⊸↓)𝕩
}
Split ← ((¬-˜⊢×·+`»⊸>)∘≠⊔⊢)

Fractran ← {
  𝕊 n‿num‿den:
  ind ← ⊑/0=den|num×n
  ⟨(n×ind⊑num)÷ind⊑den ⋄ num ⋄ den⟩
}

RunFractran ← {
  steps 𝕊 inp‿prg:
  num‿den ← <˘⍉>ToFrac¨' 'Split prg
  step ← 1
  list ← ⟨inp⟩
  {
    step +↩ 1
    out ← Fractran 𝕩
    list ∾↩ ⊑out
    out
  } _while_ {𝕊 n‿num‿den: (step<steps)∧ ∨´0=den|num} inp‿num‿den
  list
}

seq ← 200 RunFractran 2‿"17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
•Out "Generated numbers: "∾•Repr seq
•Out "Primes: "∾•Repr 1↓⌊2⋆⁼(⌈=⌊)∘(2⊸(⋆⁼))⊸/ seq
