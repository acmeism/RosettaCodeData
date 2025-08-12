BEGIN

  BITS all bits mask = NOT 16r0;
  LONG BITS long bits mask = LENG all bits mask;

  PRIO SLC = 8, SRC = 8; # SLC and SRC are not built in, define and overload them here #
  OP SLC = (BITS b, INT rotate) BITS: b SHL rotate OR b SHR ( bits width - rotate );
  OP SRC = (BITS b, INT rotate) BITS: b SHR rotate OR SHORTEN (   long bits mask
                                                              AND ( LENG b SHL ( bits width - rotate ) )
                                                              );
  # SRC and SRL are non-standard, but versions are built in to ALGOL 68R's standard prelude #

  PRIO XOR = 2;
  OP XOR = (BITS p, q) BITS: p AND NOT q OR NOT p AND q;
  # XOR is non-standard, but a version is built in to ALGOL 68G's standard prelude #

  # ALGOL 68 has 5 different ways of representing a BINary BITS - Bases: 2, 4, 8, 16 and flip/flop #
  FORMAT b5 = IF bits width > 32
              THEN $"2r"2r64d," 4r"4r32d,l"          8r"8r22d," 16r"16r16d,l"          "gl$
              ELSE $"2r"2r32d," 4r"4r16d," 8r"8r11d," 16r"16r8d,l"          "gl$
              FI;
  OP BBBBB = (BITS b)[]BITS: (b,b,b,b,b);

  PROC bitwise = (BITS a, BITS b, INT shift)VOID:
  (
    printf((
      $"         bits shorths: "gxgl$, bits shorths, "1 plus the number of extra SHORT BITS types",
      $"         bits lengths: "gxgl$, bits lengths, "1 plus the number of extra LONG BITS types",
      $"             max bits: "gl$, max bits,
      $"        long max bits: "gl$, long max bits,
      $"   long long max bits: "gl$, long long max bits,
      $"           bits width: "gxgl$, bits width, "The number of CHAR required to display BITS",
      $"      long bits width: "gxgl$, long bits width, "The number of CHAR required to display LONG BITS",
      $" long long bits width: "gxgl$, long long bits width, "The number of CHAR required to display LONG LONG BITS",
      $"         bytes shorths: "gxgl$, bytes shorths, "1 plus the number of extra SHORT BYTES types",
      $"         bytes lengths: "gxgl$, bits lengths, "1 plus the number of extra LONG BYTES types",
      $"          bytes width: "gxgl$, bytes width, "The number of CHAR required to display BYTES",
      $"     long bytes width: "gxgl$, long bytes width, "The number of CHAR required to display LONG BYTES"
    ));

    printf(($" a:       "f(b5)$, BBBBB a));
    printf(($" b:       "f(b5)$, BBBBB b));
    printf(($" a AND b: "f(b5)$, BBBBB(a AND b)));
    printf(($" a OR b:  "f(b5)$, BBBBB(a OR b)));
    printf(($" a XOR b: "f(b5)$, BBBBB(a XOR b)));
    printf(($" NOT b:   "f(b5)$, BBBBB NOT a));
    printf(($" a SHL "d": "f(b5)$, shift, BBBBB(a SHL shift)));
    printf(($" a SHR "d": "f(b5)$, shift, BBBBB(a SHR shift)));

    printf(($" a SLC "d": "f(b5)$, shift, BBBBB(a SLC shift)));
    printf(($" a SRC "d": "f(b5)$, shift, BBBBB(a SRC shift)))
COMMENT with original ALGOL 68 character set;
    printf(($" a AND b: "f(b5)$, BBBBB(a ∧ b)));
    printf(($" a OR b:  "f(b5)$, BBBBB(a ∨ b)));
    printf(($" NOT b:   "f(b5)$, BBBBB ¬ a));
    printf(($" a SHL "d": "f(b5)$, shift, BBBBB(a ↑ shift)));
    printf(($" a SHR "d": "f(b5)$, shift, BBBBB(a ↓ shift)));
Also:
    printf(($" a AND b: "f(b5)$, BBBBB(a /\ b)));
    printf(($" a OR b: "f(b5)$, BBBBB(a \/ b)));
COMMENT
  );

  bitwise(BIN 255, BIN 170, 5)
# or using alternate representations for 255 and 170 in BITS #
CO
  bitwise(2r11111111,2r10101010,5);
  bitwise(4r3333,4r2222,5);
  bitwise(8r377,8r252,5);
  bitwise(16rff,16raa,5)
END CO
END
