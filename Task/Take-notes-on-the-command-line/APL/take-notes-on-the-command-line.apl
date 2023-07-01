#!/usr/local/bin/apl -s --

∇r←ch Join ls                          ⍝ Join list of strings with character
        r←1↓∊ch,¨ls
∇

∇d←Date                                ⍝ Get system date as formatted string
        d←'/'Join ⍕¨1⌽3↑⎕TS
∇

∇t←Time;t24                            ⍝ Get system time as formatted string
        t←t24←3↑3↓⎕TS                  ⍝ Get system time
        t[1]←t[1]-12×t24[1]≥12         ⍝ If PM (hour≥12), subtract 12 from hour
        t[1]←t[1]+12×t[1]=0            ⍝ Hour 0 is hour 12 (AM)
        t←¯2↑¨'0',¨⍕¨t                 ⍝ Convert numbers to 2-digit strings
        t←(':'Join t),(1+t24[1]≥12)⊃' AM' ' PM'  ⍝ Add AM/PM and ':' separator
∇

∇Read;f
        →(¯2≡f←⎕FIO[49]'notes.txt')/0  ⍝ Read file, stop if not found
        ⎕←⊃f                           ⍝ Output file line by line
∇

∇Write note;f;_
        note←' 'Join note              ⍝ flatten input and separate with spaces
        note←Date,' ',Time,(⎕UCS 10 9),note,⎕UCS 10   ⍝ note format
        f←'a'⎕FIO[3]'notes.txt'        ⍝ append to file
        _←(⎕UCS note)⎕FIO[7]f          ⍝ write note to end of file
        _←⎕FIO[4]f                     ⍝ close the file
∇

∇Notes;note
        ⍎∊('Read' 'Write note')[1+0≠⍴note←4↓⎕ARG]
∇

Notes
)OFF
