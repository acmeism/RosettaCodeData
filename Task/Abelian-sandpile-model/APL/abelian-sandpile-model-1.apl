⍝ Collapse a sandpile in a given matrix
sandpile←{⍵-(4×S)-⊃+/(1 ¯1⊖¨⊂S)+1 ¯1⌽¨⊂S←⍵≥4}⍣≡

⍝ An ⍺-by-⍺ matrix with its middle element set to ⍵
middle←{⍺ ⍺↑(-⌈⍺ ⍺÷2)↑⍵}

⍝ Write the sandpile in ⍵ as a PPM image to file ⍺
to_ppm←{
    colors←'0 0 0' '0 1 0' '1 0 1' '1 1 0'
    ppm←∊⎕TC[2],⍨¨'P3'(⍕⍴⍵)(,⊂'1'),colors[1+,⍵]
    (⊂ppm)⎕NPUT⍺
}
