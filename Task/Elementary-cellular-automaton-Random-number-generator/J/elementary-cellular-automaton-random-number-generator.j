coclass'ca'
DOC =: 'locale creation: (RULE ; INITIAL_STATE) conew ''ca'''
create =: 3 :'''RULE STATE'' =: y'
next =: 3 :'STATE =: RULE (((8$2) #: [) {~ [: #. [: -. [: |: |.~"1 0&_1 0 1@]) STATE'
coclass'base'

coclass'rng'
coinsert'ca'
bit =: 3 :'([ next) ({. STATE)'
byte =: [: #. [: , [: bit"0 (i.8)"_
coclass'base'
