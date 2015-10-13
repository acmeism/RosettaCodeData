BEGIN
   PR precision=1000 PR
   MODE LLI = LONG LONG INT;	CO For brevity CO
   PROC mod power = (LLI base, exponent, modulus) LLI :
   BEGIN
      LLI result := 1, b := base, e := exponent;
      IF exponent < 0
      THEN
	 put (stand error, (("Negative exponent", exponent, newline)))
      ELSE
	 WHILE e > 0
	 DO
	    (ODD e | result := (result * b) MOD modulus);
	    e OVERAB 2; b := (b * b) MOD modulus
	 OD
      FI;
      result
   END;
   LLI a = 2988348162058574136915891421498819466320163312926952423791023078876139;
   LLI b = 2351399303373464486466122544523690094744975233415544072992656881240319;
   LLI m = 10000000000000000000000000000000000000000;
   printf (($"Last 40 digits = ", 40dl$, mod power (a, b, m)))
END
