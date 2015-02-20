PROGRAM RosettaIsaac;
USES StrUtils;

TYPE iMode = (iEncrypt,iDecrypt);
// TASK globals
VAR	msg : STRING = 'a Top Secret secret';
	key : STRING = 'this is my secret key';
	xctx: STRING = ''; // XOR ciphertext
	mctx: STRING = ''; // MOD ciphertext
	xptx: STRING = ''; // XOR decryption (plaintext)
	mptx: STRING = ''; // MOD decryption (plaintext)
	mode: iMode  = iEncrypt;
	
// ISAAC globals
// external results
VAR	randrsl: ARRAY[0..256] OF CARDINAL;
	randcnt: cardinal;
// internal state
VAR	mm: ARRAY[0..256] OF CARDINAL;
	aa: CARDINAL=0; bb: CARDINAL=0; cc: CARDINAL=0;


PROCEDURE Isaac;
VAR i,x,y: CARDINAL;
BEGIN
   cc := cc + 1;    // cc just gets incremented once per 256 results
   bb := bb + cc;   // then combined with bb

   FOR i := 0 TO 255 DO BEGIN
     x := mm[i];
     CASE (i mod 4) OF
		0: aa := aa xor (aa shl 13);
		1: aa := aa xor (aa shr 6);
		2: aa := aa xor (aa shl 2);
		3: aa := aa xor (aa shr 16);
     END;
     aa := mm[(i+128) mod 256] + aa;
	 y  := mm[(x shr 2) mod 256] + aa + bb;
     mm[i] := y; 	
     bb := mm[(y shr 10) mod 256] + x;
     randrsl[i]:= bb;
   END;
   // this reset was not in the original readable.c
   randcnt:=0;  // prepare to use the first set of results
END; {Isaac}


// if (flag==TRUE), then use the contents of randrsl[] to initialize mm[].
PROCEDURE mix(VAR a,b,c,d,e,f,g,h: CARDINAL);
BEGIN
	a := a xor b shl 11; d:=d+a; b:=b+c;
	b := b xor c shr  2; e:=e+b; c:=c+d;
	c := c xor d shl  8; f:=f+c; d:=d+e;
	d := d xor e shr 16; g:=g+d; e:=e+f;
	e := e xor f shl 10; h:=h+e; f:=f+g;
	f := f xor g shr  4; a:=a+f; g:=g+h;
	g := g xor h shl  8; b:=b+g; h:=h+a;
	h := h xor a shr  9; c:=c+h; a:=a+b;
END; {mix}


PROCEDURE iRandInit(flag: BOOLEAN);
VAR i,a,b,c,d,e,f,g,h: CARDINAL;
BEGIN
   aa:=0; bb:=0; cc:=0;
   a:=$9e3779b9; 	// the golden ratio

   b:=a; c:=a; d:=a; e:=a; f:=a; g:=a; h:=a;

   FOR i := 0 TO 3 DO          // scramble it
        mix(a,b,c,d,e,f,g,h);

   i:=0;
   REPEAT  // fill in mm[] with messy stuff
	IF flag THEN BEGIN     // use all the information in the seed
       a+=randrsl[i  ]; b+=randrsl[i+1]; c+=randrsl[i+2]; d+=randrsl[i+3];
       e+=randrsl[i+4]; f+=randrsl[i+5]; g+=randrsl[i+6]; h+=randrsl[i+7];
    END;

    mix(a,b,c,d,e,f,g,h);
    mm[i  ]:=a; mm[i+1]:=b; mm[i+2]:=c; mm[i+3]:=d;
    mm[i+4]:=e; mm[i+5]:=f; mm[i+6]:=g; mm[i+7]:=h;
	i+=8;
   UNTIL i>255;

   IF (flag) THEN BEGIN
   // do a second pass to make all of the seed affect all of mm
     i:=0;
     REPEAT
      a+=mm[i  ]; b+=mm[i+1]; c+=mm[i+2]; d+=mm[i+3];
      e+=mm[i+4]; f+=mm[i+5]; g+=mm[i+6]; h+=mm[i+7];
      mix(a,b,c,d,e,f,g,h);
      mm[i  ]:=a; mm[i+1]:=b; mm[i+2]:=c; mm[i+3]:=d;
      mm[i+4]:=e; mm[i+5]:=f; mm[i+6]:=g; mm[i+7]:=h;
      i+=8;
     UNTIL i>255;
   END;
   isaac();           // fill in the first set of results
   randcnt:=0;       // prepare to use the first set of results
END; {randinit}


{ Seed ISAAC with a given string.
  The string can be any size. The first 256 values will be used.}
PROCEDURE iSeed(seed: STRING; flag: BOOLEAN);
VAR i,m: CARDINAL;
BEGIN
	FOR i:= 0 TO 255 DO mm[i]:=0;
	m := Length(seed)-1;
	FOR i:= 0 TO 255 DO BEGIN
	// in case seed has less than 256 elements
        IF i>m THEN randrsl[i]:=0
			// Pascal strings are 1-based
			ELSE randrsl[i]:=ord(seed[i+1]);
	END;
	// initialize ISAAC with seed
	iRandInit(flag);
END; {iSeed}


{ Get a random 32-bit value 0..MAXINT }
FUNCTION iRandom : Cardinal;
BEGIN
	iRandom := randrsl[randcnt];
	inc(randcnt);
	IF (randcnt >255) THEN BEGIN
		Isaac();
		randcnt := 0;
	END;
END; {iRandom}


{ Get a random character in printable ASCII range }
FUNCTION iRandA: BYTE;
	BEGIN
		iRandA := iRandom mod 95 + 32;
	END;


{ convert an ASCII string to a hexadecimal string }
FUNCTION ascii2hex(s: STRING): STRING;
	VAR i,l: CARDINAL;
	BEGIN
		ascii2hex := '';
			l := Length(s);
			FOR i := 1 TO l DO
				ascii2hex += Dec2Numb(ord(s[i]),2,16);
	END;


{ XOR encrypt on random stream. Output: ASCII string }
FUNCTION Vernam(msg: STRING): STRING;
	VAR	i: CARDINAL;
	BEGIN
		Vernam := '';
		FOR i := 1 to length(msg) DO
			Vernam += chr(iRandA xor ord(msg[i]));
	END;

	
{ Get position of the letter in chosen alphabet }
FUNCTION letternum(letter, start: CHAR): byte;
	BEGIN
		letternum := (ord(letter)-ord(start));
	END;


{ Caesar-shift a character <shift> places: Generalized Vigenere }
FUNCTION Caesar(m: iMode; ch: CHAR; shift, modulo: INTEGER; start: CHAR): CHAR;
	VAR n: INTEGER;
	BEGIN
		IF m = iDecrypt THEN shift := -shift;
		n := letternum(ch,start) + shift;
		n := n MOD modulo;
		IF n<0 THEN n += modulo;
		Caesar := chr(ord(start)+n);
	END;


{ Vigenere mod 95 encryption & decryption. Output: ASCII string }
FUNCTION Vigenere(msg: STRING; m: iMode): STRING;
	VAR i: CARDINAL;
	BEGIN
		Vigenere := '';
		FOR i := 1 to length(msg) DO
			Vigenere += Caesar(m,msg[i],iRandA,95,' ');
	END;

	
BEGIN
	// 1) seed ISAAC with the key
	iSeed(key,true);
	// 2) Encryption
	mode := iEncrypt;
	// a) XOR (Vernam)
	xctx := Vernam(msg);
	// b) MOD (Vigenere)
	mctx := Vigenere(msg,mode);
	// 3) Decryption
	mode := iDecrypt;
	iSeed(key,true);
	// a) XOR (Vernam)
	xptx:= Vernam(xctx);
	// b) MOD (Vigenere)
	mptx:=Vigenere(mctx,mode);
	// program output
	Writeln('Message: ',msg);
	Writeln('Key    : ',key);
	Writeln('XOR    : ',ascii2hex(xctx));
	Writeln('MOD    : ',ascii2hex(mctx));
	Writeln('XOR dcr: ',xptx);
	Writeln('MOD dcr: ',mptx);
END.
