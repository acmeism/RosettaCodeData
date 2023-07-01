#!/usr/local/bin/apl --script

∇r ← c squeeze s
  s ← 0,s,0
  r ← 1↓¯2↓∊((s≠c)⊂s),¨c
∇

∇r ← display s
  r ← (¯2↑⍕≢s),' «««',s,'»»»'
∇

∇r ← c show s
  r ← ⊂ ("chr: '",c,"'")
  r ← r, ⊂(" in: ",display s)
  r ← r, ⊂ ("out: ",display c squeeze s)
  r ← ⊃r
∇

∇main
    s1←''
    s2←'"If I were two-faced, would I be wearing this one?"'
    s2←s2,' --- Abraham Lincoln '
    s3←'..1111111111111111111111111111111111111111111111111'
    s3←s3,'111111111111117777888'
    s4←'I never give ''em hell, I just tell the truth, and t'
    s4←s4,'hey think it''s hell. '
    s5←'                                                   '
    s5←s5,' --- Harry S Truman  '

    ⎕←' ' show s1
    ⎕←'-' show s2
    ⎕←'7' show s3
    ⎕←'.' show s4

    ⊃ {⍵ show s5}¨' -r'
∇
