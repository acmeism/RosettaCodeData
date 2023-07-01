ALPHA=: (65,:26) ];.0 a.               NB. Character Set
preprocess=: (#~ e.&ALPHA)@toupper     NB. force uppercase and discard non-alpha chars
vigEncryptRC=: 0 vig ALPHA preprocess
vigDecryptRC=: 1 vig ALPHA preprocess
