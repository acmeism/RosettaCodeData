PROGRAM RosettaIsaac;
USES
  StrUtils;

TYPE
  iMode = (iEncrypt, iDecrypt);

// TASK globals
VAR
  msg : String = 'a Top Secret secret';
  key : String = 'this is my secret key';
  xctx: String = ''; // XOR ciphertext
  mctx: String = ''; // MOD ciphertext
  xptx: String = ''; // XOR decryption (plaintext)
  mptx: String = ''; // MOD decryption (plaintext)

// ISAAC globals
VAR
  // external results
  randrsl: ARRAY[0 .. 255] OF Cardinal;
  randcnt: Cardinal;

  // internal state
  mm: ARRAY[0 .. 255] OF Cardinal;
  aa: Cardinal = 0;
  bb: Cardinal = 0;
  cc: Cardinal = 0;

PROCEDURE Isaac;
VAR
  i, x, y: Cardinal;
BEGIN
  cc := cc + 1; // cc just gets incremented once per 256 results
  bb := bb + cc; // then combined with bb

  FOR i := 0 TO 255 DO
  BEGIN
    x := mm[i];
    CASE (i MOD 4) OF
      0: aa := aa XOR (aa SHL 13);
      1: aa := aa XOR (aa SHR 6);
      2: aa := aa XOR (aa SHL 2);
      3: aa := aa XOR (aa SHR 16);
    END;
    aa := mm[(i + 128) MOD 256] + aa;
    y  := mm[(x SHR 2) MOD 256] + aa + bb;
    mm[i] := y;
    bb := mm[(y SHR 10) MOD 256] + x;
    randrsl[i] := bb;
  END;
  randcnt := 0; // prepare to use the first set of results
END; // Isaac

PROCEDURE Mix(VAR a, b, c, d, e, f, g, h: Cardinal);
BEGIN
  a := a XOR b SHL 11; d := d + a; b := b + c;
  b := b XOR c SHR  2; e := e + b; c := c + d;
  c := c XOR d SHL  8; f := f + c; d := d + e;
  d := d XOR e SHR 16; g := g + d; e := e + f;
  e := e XOR f SHL 10; h := h + e; f := f + g;
  f := f XOR g SHR  4; a := a + f; g := g + h;
  g := g XOR h SHL  8; b := b + g; h := h + a;
  h := h XOR a SHR  9; c := c + h; a := a + b;
END; // Mix

PROCEDURE iRandInit(flag: Boolean);
VAR
  i, a, b, c, d, e, f, g, h: Cardinal;
BEGIN
  aa := 0; bb := 0; cc := 0;
  a := $9e3779b9; // the golden ratio
  b := a; c := a; d := a; e := a; f := a; g := a; h := a;

  FOR i := 0 TO 3 DO // scramble it
    Mix(a, b, c, d, e, f, g, h);

  i := 0;
  REPEAT // fill in mm[] with messy stuff
    IF flag THEN
    BEGIN // use all the information in the seed
      a += randrsl[i    ]; b += randrsl[i + 1];
      c += randrsl[i + 2]; d += randrsl[i + 3];
      e += randrsl[i + 4]; f += randrsl[i + 5];
      g += randrsl[i + 6]; h += randrsl[i + 7];
    END;

    Mix(a, b, c, d, e, f, g, h);
    mm[i    ] := a; mm[i + 1] := b; mm[i + 2] := c; mm[i + 3] := d;
    mm[i + 4] := e; mm[i + 5] := f; mm[i + 6] := g; mm[i + 7] := h;
    i += 8;
  UNTIL i > 255;

  IF flag THEN
  BEGIN
    // do a second pass to make all of the seed affect all of mm
    i := 0;
    REPEAT
      a += mm[i    ]; b += mm[i + 1]; c += mm[i + 2]; d += mm[i + 3];
      e += mm[i + 4]; f += mm[i + 5]; g += mm[i + 6]; h += mm[i + 7];
      Mix(a, b, c, d, e, f, g, h);
      mm[i    ] := a; mm[i + 1] := b; mm[i + 2] := c; mm[i + 3] := d;
      mm[i + 4] := e; mm[i + 5] := f; mm[i + 6] := g; mm[i + 7] := h;
      i += 8;
    UNTIL i > 255;
  END;
  Isaac(); // fill in the first set of results
  randcnt := 0; // prepare to use the first set of results
END; // iRandInit

// Seed ISAAC with a given string.
// The string can be any size. The first 256 values will be used.
PROCEDURE iSeed(seed: String; flag: Boolean);
VAR
  i, m: Cardinal;
BEGIN
  FOR i := 0 TO 255 DO
    mm[i] := 0;
  m := Length(seed) - 1;
  FOR i := 0 TO 255 DO
  BEGIN
    // in case seed has less than 256 elements
    IF i > m THEN
      randrsl[i] := 0
      // Pascal strings are 1-based
    ELSE
      randrsl[i] := Ord(seed[i + 1]);
  END;
  // initialize ISAAC with seed
  iRandInit(flag);
END; // iSeed

// Get a random 32-bit value 0..MAXINT
FUNCTION iRandom: Cardinal;
BEGIN
  iRandom := randrsl[randcnt];
  inc(randcnt);
  IF (randcnt > 255) THEN
  BEGIN
    Isaac;
    randcnt := 0;
  END;
END; // iRandom

// Get a random character in printable ASCII range
FUNCTION iRandA: Byte;
BEGIN
  iRandA := iRandom MOD 95 + 32;
END;

// Convert an ASCII string to a hexadecimal string
FUNCTION Ascii2Hex(s: String): String;
VAR
  i: Cardinal;
BEGIN
  Ascii2Hex := '';
  FOR i := 1 TO Length(s) DO
    Ascii2Hex += Dec2Numb(Ord(s[i]), 2, 16);
END; // Ascii2Hex

// XOR encrypt on random stream. Output: ASCII string
FUNCTION Vernam(msg: String): String;
VAR
  i: Cardinal;
BEGIN
  Vernam := '';
  FOR i := 1 to Length(msg) DO
    Vernam += Chr(iRandA XOR Ord(msg[i]));
END; // Vernam

// Get position of the letter in chosen alphabet
FUNCTION LetterNum(letter, start: Char): Byte;
BEGIN
  LetterNum := (Ord(letter) - Ord(start));
END; // LetterNum

// Caesar-shift a character <shift> places: Generalized Vigenere
FUNCTION Caesar(m: iMode; ch: Char; shift, modulo: Integer; start: Char): Char;
VAR
  n: Integer;
BEGIN
  IF m = iDecrypt THEN
    shift := -shift;
  n := LetterNum(ch, start) + shift;
  n := n MOD modulo;
  IF n < 0 THEN
    n += modulo;
  Caesar := Chr(Ord(start) + n);
END; // Caesar

// Vigenere MOD 95 encryption & decryption. Output: ASCII string
FUNCTION Vigenere(msg: String; m: iMode): String;
VAR
  i: Cardinal;
BEGIN
  Vigenere := '';
  FOR i := 1 to Length(msg) DO
    Vigenere += Caesar(m, msg[i], iRandA, 95, ' ');
END; // Vigenere

BEGIN
  // 1) seed ISAAC with the key
  iSeed(key, true);
  // 2) Encryption
  // a) XOR (Vernam)
  xctx := Vernam(msg);
  // b) MOD (Vigenere)
  mctx := Vigenere(msg, iEncrypt);
  // 3) Decryption
  iSeed(key, true);
  // a) XOR (Vernam)
  xptx := Vernam(xctx);
  // b) MOD (Vigenere)
  mptx := Vigenere(mctx, iDecrypt);
  // program output
  Writeln('Message: ', msg);
  Writeln('Key    : ', key);
  Writeln('XOR    : ', Ascii2Hex(xctx));
  Writeln('MOD    : ', Ascii2Hex(mctx));
  Writeln('XOR dcr: ', xptx);
  Writeln('MOD dcr: ', mptx);
END.
