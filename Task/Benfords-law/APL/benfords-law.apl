task←{
    benf ← ≢÷⍨(⍳9)(+/∘.=)(⍎⊃∘⍕)¨

    fibs ← (⊢,(+/¯2↑⊢))⍣998⊢1 1

    exp ← 10⍟1+÷⍳9
    obs ← benf fibs

    ⎕←'Expected  Actual'⍪5⍕exp,[1.5]obs
}
