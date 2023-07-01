: INPUT# ( -- n true | false )
   16 INPUT$ NUMBER? NIP
   DUP 0= IF NIP THEN ;
