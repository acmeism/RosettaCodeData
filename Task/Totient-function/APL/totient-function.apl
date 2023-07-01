task←{
    totient ← 1+.=⍳∨⊢
    prime   ← totient=-∘1

    ⎕←'Index' 'Totient' 'Prime',(⊢⍪totient¨,[÷2]prime¨)⍳25
    {⎕←'There are' (+/prime¨⍳⍵) 'primes below' ⍵}¨100 1000 10000
}
