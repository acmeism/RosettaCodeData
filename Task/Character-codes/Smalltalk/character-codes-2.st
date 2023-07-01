Transcript showCR:$a codePoint.
Transcript showCR:(Character codePoint:97).
Transcript showCR:(98 asCharacter).

'abcmøøse𝔘𝔫𝔦𝔠𝔬𝔡𝔢' do:[:ch |
    Transcript showCR:ch codePoint
]
