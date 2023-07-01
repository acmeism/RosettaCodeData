 canonicalize←{
    nums←(2⊃⎕VFI)¨(~⍵∊'./')⊆⍵
    ip len←(4↑nums)(5⊃nums)
    ip←(32/2)⊤256⊥⊃¨ip
    ip←ip∧32↑len⍴1
    ip←(4/256)⊤2⊥ip
    (1↓∊'.',¨⍕¨ip),'/',⍕len
 }
