DATA: s1 TYPE string,
      s2 TYPE string.

s1 = 'Hello'.
CONCATENATE s1 ' literal' INTO s2 RESPECTING BLANKS.
WRITE: / s1.
WRITE: / s2.
