recaman←{⎕IO←0
    genNext←{
        R←⍵[N-1]-N←≢⍵
        (R<0)∨(R∊⍵):⍵,⍵[N-1]+N
        ⍵,⍵[N-1]-N
    }
    ⎕←'First 15: '
    ⎕←reca←(genNext⍣14),0
    ⎕←'First repetition: '
    ⎕←⊃⌽reca←genNext⍣{⍺≢∪⍺}⊢reca
    ⎕←'Length of sequence containing [0..1000]:'
    ⎕←≢reca←genNext⍣{(⍳1001)∧.∊⊂⍺}⊢reca
}
