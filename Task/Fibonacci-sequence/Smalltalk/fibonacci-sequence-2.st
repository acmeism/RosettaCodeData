Integer >> fibR
    (self > 1) ifTrue:[
        ^ (self - 1) fibR + (self - 2) fibR
    ].
    ^ self
