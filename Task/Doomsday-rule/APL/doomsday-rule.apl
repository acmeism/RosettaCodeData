weekday←{⎕IO←1
    days←'Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday'
    leap←4 7∊⍨2⊥0=4 100 400∘|
    ld←4 7 1 4 2 6 4 1 5 3 7 5
    nd←3 7 7 4 2 6 4 1 5 3 7 5
    y m d←⍵
    c←⌊y÷100 ⋄ r←100|y
    s←⌊r÷12  ⋄ t←12|r
    can←7|2+5×4|c
    doom←7|s+t+can+⌊t÷4
    anchor←m⊃(1+leap y)⊃nd ld
    (1+7|7+doom+d-anchor)⊃days
}
