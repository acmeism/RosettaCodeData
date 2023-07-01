:Namespace Turing
    ⍝ Run Turing machine until it halts
    ∇r←RunTuring (rules init halts blank itape);state;rt;lt;next
        state←init
        lt←⍬
        rt←,blank
        :If 0≠≢itape ⋄ rt←itape ⋄ :EndIf
        :While ~(⊂state)∊halts
            next←((⊂state(⊃rt))≡¨↓rules[;⍳2])⌿rules
            'No rule applies!'⎕SIGNAL(0=≢next)/11
            (⊃rt)←⊃next[1;3]
            state←⊃next[1;5]
            :Select ⊃next[1;4]
            :Case 'stay' ⋄ ⍝nothing
            :Case 'right'
                lt,⍨←⊃rt
                rt←1↓rt
                :If 0=≢rt ⋄ rt←,blank ⋄ :EndIf
            :Case 'left'
                :If 0=≢lt ⋄ lt←,blank ⋄ :EndIf
                rt,⍨←⊃lt
                lt←1↓lt
            :Else
                'Invalid action'⎕SIGNAL 11
            :EndSelect
        :EndWhile
        r←(⌽lt),rt
    ∇

    ⍝ Display the resulting tape neatly
    ∇r←len Display t
        r←(len⌊≢t)↑t
        →(len≥≢t)/0
        r,←'... (total length: ',(⍕≢t),')'
    ∇

    ⍝ Simple incrementer
    ∇t←∆1_SimpleIncrementer
        t ←⊂'q0' '1' '1' 'right' 'q0'
        t,←⊂'q0' 'B' '1' 'stay'  'qf'
        t←(↑t) 'q0' (,⊂'qf') 'B' '111'
    ∇

    ⍝ Three state beaver
    ∇t←∆2_ThreeStateBeaver
        t ←⊂'a' '0' '1' 'right' 'b'
        t,←⊂'a' '1' '1' 'left'  'c'
        t,←⊂'b' '0' '1' 'left'  'a'
        t,←⊂'b' '1' '1' 'right' 'b'
        t,←⊂'c' '0' '1' 'left'  'b'
        t,←⊂'c' '1' '1' 'stay'  'halt'
        t←(↑t) 'a' (,⊂'halt') '0' ''
    ∇

    ⍝ Five state beaver
    ∇t←∆3_FiveStateBeaver
        t ←⊂'A' '0' '1' 'right' 'B'
        t,←⊂'A' '1' '1' 'left'  'C'
        t,←⊂'B' '0' '1' 'right' 'C'
        t,←⊂'B' '1' '1' 'right' 'B'
        t,←⊂'C' '0' '1' 'right' 'D'
        t,←⊂'C' '1' '0' 'left'  'E'
        t,←⊂'D' '0' '1' 'left'  'A'
        t,←⊂'D' '1' '1' 'left'  'D'
        t,←⊂'E' '0' '1' 'stay'  'H'
        t,←⊂'E' '1' '0' 'left'  'A'
        t←(↑t) 'A' (,⊂'H') '0' ''
    ∇

    ⍝ Run all of them and display the results
    ∇RunAll;m;ms
        ms←('∆'=⊃¨ms)/ms←⎕NL¯3
        :For m :In ms
            ⎕←(1↓m),': ',(32 Display RunTuring ⍎m)
        :EndFor
    ∇
:EndNamespace
