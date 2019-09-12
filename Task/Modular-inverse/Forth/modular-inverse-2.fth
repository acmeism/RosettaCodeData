: modinv ( a m - inv)
  dup 1-              \ a m (m != 1)?
  if                  \ a m
    tuck 1 0          \ m0 a m 1 0
    begin             \ m0 a m inv x0
      2>r over 1 >    \ m0 a m (a > 1)?       R: inv x0
    while             \ m0 a m                R: inv x0
      tuck /mod       \ m0 m (a mod m) (a/m)  R: inv x0
      r> tuck *       \ m0 a' m' x0 (a/m)*x0  R: inv
      r> swap -       \ m0 a' m' x0 (inv-q)   R:
    repeat            \ m0 a' m' inv' x0'
    2drop             \ m0                    R: inv x0
    2r> drop          \ m0 inv                R:
    dup 0<            \ m0 inv (inv < 0)?
    if over + then    \ m0 (inv + m0)
  then                \ x inv'
  nip                 \ inv
;
