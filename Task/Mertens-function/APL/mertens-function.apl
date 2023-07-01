mertens←{
    step  ← {⍵,-⍨/⌽1,⍵[⌊n÷1↓⍳n←1+≢⍵]}
    m1000 ← step⍣999⊢,1
    zero  ← m1000+.=0
    cross ← +/(~∧1⌽⊢)m1000≠0
    ⎕←'First 99 Mertens numbers:'
    ⎕←10 10⍴'∘',m1000
    ⎕←'M(N) is zero ',(⍕zero),' times.'
    ⎕←'M(N) crosses zero ',(⍕cross),' times.'
}
