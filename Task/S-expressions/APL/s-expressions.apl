sexp←{
    wspace←' ',⎕TC                  ⍝ whitespace is space, tab, cr, lf

    ⍝ turn string into number if possible
    num←{
        0=≢⍵:⍬                         ⍝ empty = nope
        (⊃⍵)∊'-¯':-∇1↓⍵                ⍝ negative?
        (1≥⍵+.='.')∧⍵∧.∊⊂⎕D,'.':⍎⍵     ⍝ number: all digits and 0 or 1 points
        ⍬                              ⍝ otherwise, nope.
    }

    ⍝ tokenize (0=brackets, 1=strings, 2=atoms)
    tok←{
        d←(~∧\⍵∊wspace)/⍵              ⍝ ignore leading whitespace
        d≡'':d                         ⍝ empty input = empty output
        s←1↑d ⋄ r←1↓d                  ⍝ start and rest
        s∊'()':(⊂0,⊂s),∇r              ⍝ brackets: just the bracket
        sb←∧\~('"'=r)∧'\'≠¯1⌽r         ⍝ strings: up to first " not preceded by \
        sd←(1⌽sd≠'"')/sd←sb/r          ⍝ without escape characters
        s='"':(⊂1,⊂sd),∇1↓(~sb)/r
        atm←∧\~d∊wspace,'()"'          ⍝ atom: up to next whitespace, () or "
        (⊂2,⊂atm/d),∇(~atm)/d
    }

    ⍝ build structure from tokens
    build←{
        ⍺←⍬
        0=≢⍵:⍺ ⍬                       ⍝ empty input = done
        typ tok←⊃⍵                     ⍝ current token and type
        rst←1↓⍵                        ⍝ rest of tokens
        tok≡,'(':(⍺,⊂0 l)∇r⊣l r←∇rst   ⍝ open bracket: go down a level
        tok≡,')':⍺ rst                 ⍝ close bracket: go up a level
        typ=1:(⍺,⊂1 tok)∇rst           ⍝ string: type 1
        0≠≢n←num tok:(⍺,⊂2(,n))∇rst    ⍝ number: type 2
        (⍺,⊂3 tok)∇rst                 ⍝ symbol: type 3
    }

    ⍝ check that a string was passed in
    (''≢0↑⍵)∨1≠⍴⍴⍵:⎕SIGNAL⊂('EN'11)('Message' 'Input must be a char vector')

    ⍝ check that all strings are closed
    quot←('"'=⍵)∧'\'≠¯1⌽⍵
    0≠2|+/quot:⎕SIGNAL⊂('EN'11)('Message' 'Open string')

    ⍝ check that all brackets match (except those in strings)
    nest←+\+⌿1 ¯1×[1]'()'∘.=(~2|+\quot)/⍵
    (0≠¯1↑nest)∨0<.∨nest:⎕SIGNAL⊂('EN'11)('Message' 'Mismatched parentheses')

    ⊃build tok ⍵
}

pretty←{
    ⍝ Prettyprinter for parsed S-expressions
    NL←⎕tc[2]
    ∊∇{
        typ itm←⍵
        typ=3:itm,NL                          ⍝ Atom
        typ=2:(⍕itm),NL                       ⍝ Number
        typ=1:('"',('"'⎕R'\\"'⊢itm),'"'),NL   ⍝ String
        typ=0:'(',NL,('^'⎕R' '⊢⍺⍺ itm),')',NL ⍝ List
    }¨⍵
}
