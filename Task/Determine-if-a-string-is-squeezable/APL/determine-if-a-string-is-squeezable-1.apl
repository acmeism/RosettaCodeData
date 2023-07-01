task←{
    ⍝ Squeeze a string
    squeeze ← ⊢(/⍨)≠∨1,1↓⊣≠¯1⌽⊢

    ⍝ Display string and length in the manner given in the task
    display ← {(¯2↑⍕≢⍵),' «««',⍵,'»»»'}

    ⍝ Squeeze string and display output
    show ← {
        r←  ⊂'chr: ''',⍺,''''
        r←r,⊂' in: ',display ⍵
        r←r,⊂'out: ',display ⍺ squeeze ⍵
        ↑r,⊂''
    }

    ⍝ Strings from the task
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
    {⎕←⍵ show s5}¨' -r'  ⍝⍝ note use of 'show' here in a lambda (dfn)
}
