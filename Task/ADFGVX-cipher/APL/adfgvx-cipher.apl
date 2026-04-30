adfgvx←{
    n←⎕NS''
    n.split←↑{⍺≥⍴⍵:⊂⍵ ⋄ (⊂⍺↑⍵),⍺∇⍺↓⍵}

    n.enc←⍺{
        t←∊(∘.,⍨'ADFGVX')[⊃∘⍸∘(⍺⍺∘=)¨⍵]
        w←↓⍉((⍴⍵⍵)split t)[;⍋⍵⍵]
        1↓∊' ',¨w~¨' '
    }⍵

    n.dec←⍺{
        t←↓2 split (∊(⍉↑⍵⊆⍨' '≠⍵)[;⍋⍋⍵⍵])~' '
        ⍺⍺['ADFGVX'∘⍳¨t]
    }⍵

    n
}

adfgvx_test←{
    square←6 6⍴(⎕A,⎕D)[?⍨36]
    ⎕←'Polybius square:'
    ⎕←' ─ADFGVX','│┼││││││','A D F G V X' ⍪'─'⍪(11⍴1 0)\square
    ⎕←''

    key←{
        file←'e:\unixdict.txt'
        dict←(~data∊⎕TC)⊆data←⊃⎕NGET file
        dict←(⍵{⍺=≢⍵}¨dict)/dict
        dict←({⍵≡∪⍵}¨dict)/dict
        1⎕C ⊃dict[?⍴dict]
    }9
    ⎕←'Key: ',key

    a←square adfgvx key

    ⎕←'Plaintext: ',plaintext←'ATTACKAT1200AM'
    ⎕←'Encrypted: ',encrypted←a.enc plaintext
    ⎕←'Decrypted: ',a.dec encrypted
}
