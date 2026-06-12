extraPrimes←{
    pd←0 2 3 5 7
    ds←↓⍉(∧⌿ds∊pd)/ds←10(⊥⍣¯1)1↓⍳⍵
    ds←↑((∧/2(≤≥0=⊢)/⊢)¨ds)/ds
    ns←(ns≤⍵)/ns←10⊥⍉ds
    ss←+/(⍴ns)↑ds
    sieve←~(1+⌈/ns,ss){
        r←1↓⍺⍴(⍺⌊⍵)↑1
        ∨/r:(r∧⍵≠⍳⍺-1)∨⍺∇1+2*r⍳1
        (⍺-1)/0
    }2
    (sieve[ns]∧sieve[ss])/ns
}
