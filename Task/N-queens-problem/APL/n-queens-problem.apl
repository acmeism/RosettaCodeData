⍝Solution
accm←{⍺,((⍴⍵)=⍴⊃⍺)↑⊂⍵}
atk←{∪∊(⊂⍵)+¯1 0 1×⊂⌽⍳⍴⍵}
dfs←{⊃∇⍨/⌽(⊂⍺ ⍺⍺ ⍵),⍺ ⍵⍵ ⍵}
qfmt←{⍵∘.=⍳⍴⍵}
subs←{(⊂⍵),¨(⍳⍴⊃⍺)~atk ⍵}
queens←{qfmt¨(↓0 ⍵⍴0)accm dfs subs ⍬}
printqueens←{i←1⋄{⎕←'answer'i⋄⎕←⍵⋄i+←1}¨queens ⍵}

⍝Example
printqueens 6
