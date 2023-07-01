markov←{
    trim←{(~(∧\∨⌽∘(∧\)∘⌽)⍵∊⎕UCS 9 32)/⍵}
    rules←(~rules∊⎕UCS 10 13)⊆rules←80 ¯1 ⎕MAP ⍺
    rules←('#'≠⊃¨rules)/rules
    rules←{
        norm←' '@(9=⎕UCS)⊢⍵
        spos←⍸' -> '⍷norm
        pat←trim spos↑⍵
        repl←trim(spos+2)↓⍵
        term←'.'=⊃repl
        term pat(term↓repl)
    }¨rules
    apply←{
        0=⍴rule←⍸∨/¨(2⊃¨⍺)⍷¨⊂⍵:⍵
        term pat repl←⊃⍺[⊃rule]
        idx←(⊃⍸pat⍷⍵)-1
        ⍺ ∇⍣(~term)⊢(idx↑⍵),repl,(idx+≢pat)↓⍵
    }
    rules apply ⍵
}
