coclass 'assocArray'
    encode=: 'z', (a.{~;48 65 97(+ i.)&.>10 26 26) {~ 62x #.inv 256x #. a.&i.
    get=: ".@encode
    has=: 0 <: nc@<@encode
    set=:4 :'(encode x)=:y'
