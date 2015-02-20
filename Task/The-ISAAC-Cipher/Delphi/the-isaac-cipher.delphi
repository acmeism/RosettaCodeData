{$apptype console}
PROGRAM RosettaIsaac;
USES SysUtils;

// TASK globals
VAR msg : STRING = 'a Top Secret secret';
VAR key : STRING = 'this is my secret key';
VAR xctx: STRING = ''; // XOR ciphertext
VAR mctx: STRING = ''; // MOD ciphertext
	
// ISAAC globals
// external results
VAR randrsl: ARRAY[0..256] OF CARDINAL;
VAR randcnt: cardinal;
// internal state
VAR mm: ARRAY[0..256] OF CARDINAL;
VAR aa: CARDINAL=0; bb: CARDINAL=0; cc: CARDINAL=0;


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
   // this reset was not in original readable.c!
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
       a:=a+randrsl[i  ]; b:=b+randrsl[i+1]; c:=c+randrsl[i+2]; d:=d+randrsl[i+3];
       e:=e+randrsl[i+4]; f:=f+randrsl[i+5]; g:=g+randrsl[i+6]; h:=h+randrsl[i+7];
    END;

    mix(a,b,c,d,e,f,g,h);
    mm[i  ]:=a; mm[i+1]:=b; mm[i+2]:=c; mm[i+3]:=d;
    mm[i+4]:=e; mm[i+5]:=f; mm[i+6]:=g; mm[i+7]:=h;
	i:=i+8;
   UNTIL i>255;

   IF (flag) THEN BEGIN
   // do a second pass to make all of the seed affect all of mm
     i:=0;
     REPEAT
      a:=a+mm[i  ]; b:=b+mm[i+1]; c:=c+mm[i+2]; d:=d+mm[i+3];
      e:=e+mm[i+4]; f:=f+mm[i+5]; g:=g+mm[i+6]; h:=h+mm[i+7];
      mix(a,b,c,d,e,f,g,h);
      mm[i  ]:=a; mm[i+1]:=b; mm[i+2]:=c; mm[i+3]:=d;
      mm[i+4]:=e; mm[i+5]:=f; mm[i+6]:=g; mm[i+7]:=h;
      i:=i+8;
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
	result := randrsl[randcnt];
	inc(randcnt);
	IF (randcnt >255) THEN BEGIN
		Isaac();
		randcnt := 0;
	END;
END; {iRandom}


{ Get a random character in printable ASCII range }
FUNCTION iRandA: BYTE;
	BEGIN
		result := iRandom mod 95 + 32;
	END;

	
{ convert an ASCII string to a hexadecimal string }
FUNCTION ascii2hex(s: STRING): STRING;
	VAR i,l: CARDINAL;
	BEGIN
		result := '';
			l := Length(s);
			FOR i := 1 TO l DO
				result := result + IntToHex(ord(s[i]),2);
	END;


{ XOR encrypt on random stream. Output: string of hex chars }
FUNCTION Vernam(msg: STRING): STRING;
	VAR	i: CARDINAL;
	BEGIN
		result := '';
		FOR i := 1 to length(msg) DO
			result := result + chr(iRandA xor ord(msg[i]));
	result := ascii2hex(result);
	END;

	
{ Get position of the letter in chosen alphabet }
FUNCTION letternum(letter, start: CHAR): byte;
	BEGIN
		result := (ord(letter)-ord(start));
	END;


{ Caesar-shift a character <shift> places: Generalized Vigenere }
FUNCTION Caesar(ch: CHAR; shift, modulo: INTEGER; start: CHAR): CHAR;
	VAR n: INTEGER;
	BEGIN
		n := letternum(ch,start) + shift;
		n := n MOD modulo;
		result := chr(ord(start)+n);
	END;

{ Vigenere mod 95 encryption. Output: string of hex chars }
FUNCTION Vigenere(msg: STRING): STRING;
	VAR i: CARDINAL;
	BEGIN
		result := '';
		FOR i := 1 to length(msg) DO
			result := result + Caesar(msg[i],iRandA,95,' ');
		result := ascii2hex(result);
	END;

	
BEGIN
	// 1) seed ISAAC with the key
	iSeed(key,true);
	// 2) Vernam XOR encryption
	xctx := Vernam(msg);
	// 3) MOD encryption
	mctx := Vigenere(msg);
	// program output
	Writeln('Message: ',msg);
	Writeln('Key    : ',key);
	Writeln('XOR    : ',xctx);
	Writeln('MOD    : ',mctx);
END.
