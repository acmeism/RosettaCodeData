R←LNS V;T
R←0⍴0                    ⍝ initiate empty reply
LOOP:T←↑⍴↑(=\V)⊂V←,V     ⍝ t is the length of the 1st digit's run
R←R,T,↑V                 ⍝ append t and the 1st digit
→(0≠↑⍴V←T↓V)/LOOP        ⍝ drop t digits and iterate
