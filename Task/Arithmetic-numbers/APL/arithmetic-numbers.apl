task←{
    facs   ← ⍸0=⍳|⊢
    aritm  ← (0=≢|+/)∘facs
    comp   ← 2<(≢facs)
    aritms ← ⍸aritm¨⍳15000

    ⎕←'First 100 arithmetic numbers:'
    ⎕←10 10⍴aritms
    {
        ⎕←''
        ⎕←'The ',(⍕⍵),'th arithmetic number: ',(⍕aritms[⍵])
        ncomps ← +/comp¨⍵↑aritms
        ⎕←'Of the first ',(⍕⍵),' arithmetic numbers, ',(⍕ncomps),' are composite.'
    }¨10*3 4
}
