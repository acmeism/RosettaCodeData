main:(

  SHORT SHORT INT ssdec = SHORT SHORT 727,
            sshex = ABS SHORT SHORT 16r2d7,
            ssoct = ABS SHORT SHORT 8r1327,
            ssbin = ABS SHORT SHORT 2r1011010111;

  SHORT INT sdec = SHORT 727,
            shex = ABS SHORT 16r2d7,
            soct = ABS SHORT 8r1327,
            sbin = ABS SHORT 2r1011010111;

  INT dec = 727,
      hex = ABS 16r2d7,
      oct = ABS 8r1327,
      bin = ABS 2r1011010111;

  LONG INT ldec = LONG 727,
           lhex = ABS LONG 16r2d7,
           loct = ABS LONG 8r1327,
           lbin = ABS LONG 2r1011010111;

CO
  LONG LONG INT lldec = LONG LONG 727,
           llhex = ABS LONG LONG 16r2d7,
           lloct = ABS LONG LONG 8r1327,
           llbin = ABS LONG LONG 2r1011010111
# etc ... #
END CO

  print(("SHORT SHORT INT:", ssdec, sshex, ssoct, ssbin, new line));
  print(("      SHORT INT:", sdec, shex, soct, sbin, new line));
  print(("            INT:", dec, hex, oct, bin, new line));
  print(("       LONG INT:", ldec, lhex, loct, lbin, new line))
CO LONG LONG INT not supported by ELLA ALGOL 68RS
  print(("LONG LONG INT:", new line, lldec, new line, llhex, new line, lloct, new line, llbin, new line))
# etc ... #
END CO

)
