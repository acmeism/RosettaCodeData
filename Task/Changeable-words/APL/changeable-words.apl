 changeable_words←{
    d←(11<≢¨d)/d←(~d∊⎕TC)⊆d←⊃⎕NGET'unixdict.txt'
    ↑⊃,/{,/20↑¨⍵[↑⍸∘.(1=(+/≠))⍨⍵]}¨{⊂d[⍵]}⌸≢¨d
 }
