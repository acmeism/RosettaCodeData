numerals=: '0123456789abcdefghijklmnopqrstuvwxyz'
baseNtoL=: numerals {~ #.inv
baseLtoN=: [ #. numerals i. ]
