'hello' size -> 5
'hello' utf8Encoded  size -> 5
'hello' utf8Encoded asByteArray -> #[104 101 108 108 111]
#[104 101 108 108 111] asString -: 'hello'

'møøse' size -> 5
'møøse' utf8Encoded size -> 7
'møøse' utf8Encoded asByteArray -> #[109 195 184 195 184 115 101]
#[109 195 184 195 184 115 101] utf8Decoded ->'møøse'

'𝔘𝔫𝔦𝔠𝔬𝔡𝔢' size -> 7
'𝔘𝔫𝔦𝔠𝔬𝔡𝔢' utf8Encoded size -> 28
'𝔘𝔫𝔦𝔠𝔬𝔡𝔢' utf8Encoded asByteArray -> #[240 157 148 152 240 157 148 171 240 157 148 166 240 157 148 160 240 157 148 172 240 157 148 161 240 157 148 162]
'𝔘𝔫𝔦𝔠𝔬𝔡𝔢' utf16Encoded size -> 14
'𝔘𝔫𝔦𝔠𝔬𝔡𝔢' utf8Encoded asWordArray -> WordArray(55349 56600 55349 56619 55349 56614 55349 56608 55349 56620 55349 56609 55349 56610)
