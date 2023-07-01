truth←{
    op←⍉↑'~∧∨≠→('(4 3 2 2 1 0)
    order←⍬⍬{
        out stk←⍺
        0=≢⍵:out,⌽stk
        c rst←(⊃⍵) (1↓⍵)
        c∊⎕A:((out,c)stk)∇rst
        c∊'01':((out,⍎c)stk)∇rst
        (c≠'(')∧(≢op)≥n←op[;1]⍳c:rst∇⍨out{
            cnd←⌽∧\⌽(⍵≠'(')∧op[op[;1]⍳⍵;2]≥op[n;2]
            (⍺,⌽cnd/⍵)(((~cnd)/⍵),c)
        }stk
        c='(':(out(stk,c))∇rst
        c=')':rst∇⍨out{
            ⍬≡par←⍸'('=⍵:'Missing ('⎕SIGNAL 11
            n←⌈/par
            (⍺,n↓⍵)((n-1)↑⍵)
        }stk
        ('Invalid character ',c)⎕SIGNAL 11
    }1(819⌶)⍵~4↑⎕TC
    '('∊order:'Missing )'⎕SIGNAL 11
    nvar←≢vars←∪(order∊⎕A)/order
    eval←{
        ⍺←⍬
        0=≢⍵:{
            1≠≢⍵:'Missing operator'⎕SIGNAL 11 ⋄ ⊃⍵
        }⍺
        c rst←(⊃⍵) (1↓⍵)
        c∊⎕A:(⍺⍺[vars⍳c],⍺)∇rst
        c∊0 1:(c,⍺)∇rst
        c='~':(⍺≠1 0↑⍨≢⍺)∇rst ⊣ 'Missing operand'⎕SIGNAL(0=≢⍺)/11
        c∊op[;1]:({
            2>≢⍵:'Missing operand'⎕SIGNAL 11
            c='→':(≥/2↑⍵),2↓⍵
            ((⍎c)/2↑⍵),2↓⍵
        }⍺)∇rst
    }
    _←(nvar/0) eval order
    confs←⍉(nvar/2)⊤¯1+⍳2*nvar
    tab←'FT│'[1+(confs,2),{⍵ eval order}¨↓confs]
    tab←↑,/ ' ',¨tab
    hdr←((∊,/(' ',¨vars),' '),[0.5]'─'),⍪'│┼'
    hdr←hdr,(' ',⍵,' '),[0.5]'─'
    hdr⍪(,∘' '⍣(⊃⊃-/1↓¨⍴¨hdr tab))tab
}
