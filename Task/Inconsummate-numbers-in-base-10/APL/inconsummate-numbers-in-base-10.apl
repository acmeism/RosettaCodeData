task←{
    gen ← ⍳~(⊢(/⍨)⌊=⊢)∘(⊢÷(+/⍎¨∘⍕)¨)∘⍳∘(⊢×9×≢∘⍕)
    incons ← gen 9999
    ⎕←'The first 50 inconsummate numbers:'
    ⎕←5 10⍴50↑incons
    ⎕←'The 1000th inconsummate number:',incons[1000]
}
