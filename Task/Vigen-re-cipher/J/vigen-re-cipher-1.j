NB.*vig c Vigenère cipher
NB. cipher=. key 0 vig charset plain
NB. plain=. key 1 vig charset cipher
vig=: conjunction define
:
  r=. (#y) $ n i.x
  n {~ (#n) | (r*_1^m) + n i.y
)

ALPHA=: (65,:26) ];.0 a.               NB. Character Set
preprocess=: (#~ e.&ALPHA)@toupper     NB. force uppercase and discard non-alpha chars
vigEncryptRC=: 0 vig ALPHA preprocess
vigDecryptRC=: 1 vig ALPHA preprocess
