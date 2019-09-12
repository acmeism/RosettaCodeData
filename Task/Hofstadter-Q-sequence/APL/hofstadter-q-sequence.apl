∇ Q_sequence;seq;size
    size←100000
    seq←{⍵,+/⍵[(1+⍴⍵)-¯2↑⍵]}⍣(size-2)⊢1 1

    ⎕←'The first 10 terms are:', seq[⍳10]
    ⎕←'The 1000th term is:', seq[1000]
    ⎕←(+/ 2>/seq),'terms were preceded by a larger term.'
∇
