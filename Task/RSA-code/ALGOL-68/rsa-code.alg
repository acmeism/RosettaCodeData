COMMENT
   First cut.  Doesn't yet do blocking and deblocking.  Also, as
   encryption and decryption are identical operations but for the
   reciprocal exponents used, only one has been implemented below.

   A later release will address these issues.
COMMENT

BEGIN
   PR precision=1000 PR
   MODE LLI = LONG LONG INT;    CO For brevity CO
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
   PROC modular inverse = (LLI a, m) LLI :
   BEGIN
      PROC extended gcd = (LLI x, y) []LLI :
      BEGIN
	 LLI v := 1, a := 1, u := 0, b := 0, g := x, w := y;
	 WHILE w>0
	 DO
	    LLI q := g % w, t := a - q * u;
	    a := u; u := t;
	    t := b - q * v;
	    b := v; v := t;
	    t := g - q * w;
	    g := w; w := t
	 OD;
	 a PLUSAB (a < 0 | u | 0);
	 (a, b, g)
      END;
      [] LLI egcd = extended gcd (a, m);
      (egcd[3] > 1 | 0 | egcd[1] MOD m)
   END;
   PROC number to string = (LLI number) STRING :
   BEGIN
      [] CHAR map = (blank + "ABCDEFGHIJKLMNOPQRSTUVWXYZ")[@0];
      LLI local number := number;
      INT length := SHORTEN SHORTEN ENTIER long long log(number) + 1;
      (ODD length | length PLUSAB 1);
      [length % 2] CHAR text;
      FOR i FROM length % 2 BY -1 TO 1
      DO
	 INT index = SHORTEN SHORTEN (local number MOD 100);
	 text[i] := (index > 26 | "?" | map[index]);
	 local number := local number % 100
      OD;
      text
   END;
CO The parameters of a particular RSA cryptosystem CO
   LLI p = 3490529510847650949147849619903898133417764638493387843990820577;
   LLI q = 32769132993266709549961988190834461413177642967992942539798288533;
   LLI n = p * q;
   LLI phi n = (p-1) * (q-1);
   LLI e = 9007;
   LLI d = modular inverse (e, phi n);
CO A ciphertext CO
   LLI cipher text = 96869613754622061477140922254355882905759991124574319874695120930816298225145708356931476622883989628013391990551829945157815154;
CO Print out the corresponding plain text CO
   print (number to string (mod power (ciphertext, d, n)))
END
