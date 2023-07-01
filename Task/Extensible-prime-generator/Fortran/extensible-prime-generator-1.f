      DO WHILE(F*F <= LST)         !But, F*F might overflow the integer limit so instead,
      DO WHILE(F <= LST/F)                      !Except, LST might also overflow the integer limit, so
      DO WHILE(F <= (IST + 2*(SBITS - 1))/F)    !Which becomes...
      DO WHILE(F <= IST/F + (MOD(IST,F) + 2*(SBITS - 1))/F) !Preserving the remainder from IST/F.
