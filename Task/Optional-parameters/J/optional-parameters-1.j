srtbl=: verb define
  '' srtbl y
:
  '`ordering column reverse'=. x , (#x)}. ]`0:`0:
  |.^:reverse y /: ordering (column {"1 ])y
)
