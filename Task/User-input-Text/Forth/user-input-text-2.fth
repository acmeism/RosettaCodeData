: INPUT# ( -- u true | false )
  0. 16 INPUT$ DUP >R
  >NUMBER NIP NIP
  R> <> DUP 0= IF NIP THEN ;
