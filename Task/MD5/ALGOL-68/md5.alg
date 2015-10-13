# Based on wikipedia article pseudocode #

# s specifies the per-round shift amounts #
[]INT s = (7,12,17,22, 7,12,17,22, 7,12,17,22, 7,12,17,22,
           5, 9,14,20, 5, 9,14,20, 5, 9,14,20, 5, 9,14,20,
           4,11,16,23, 4,11,16,23, 4,11,16,23, 4,11,16,23,
           6,10,15,21, 6,10,15,21, 6,10,15,21, 6,10,15,21);

[]BITS k = (16rd76aa478, 16re8c7b756, 16r242070db, 16rc1bdceee,
	    16rf57c0faf, 16r4787c62a, 16ra8304613, 16rfd469501,
	    16r698098d8, 16r8b44f7af, 16rffff5bb1, 16r895cd7be,
	    16r6b901122, 16rfd987193, 16ra679438e, 16r49b40821,
	    16rf61e2562, 16rc040b340, 16r265e5a51, 16re9b6c7aa,
	    16rd62f105d, 16r02441453, 16rd8a1e681, 16re7d3fbc8,
	    16r21e1cde6, 16rc33707d6, 16rf4d50d87, 16r455a14ed,
	    16ra9e3e905, 16rfcefa3f8, 16r676f02d9, 16r8d2a4c8a,
	    16rfffa3942, 16r8771f681, 16r6d9d6122, 16rfde5380c,
	    16ra4beea44, 16r4bdecfa9, 16rf6bb4b60, 16rbebfbc70,
	    16r289b7ec6, 16reaa127fa, 16rd4ef3085, 16r04881d05,
	    16rd9d4d039, 16re6db99e5, 16r1fa27cf8, 16rc4ac5665,
	    16rf4292244, 16r432aff97, 16rab9423a7, 16rfc93a039,
	    16r655b59c3, 16r8f0ccc92, 16rffeff47d, 16r85845dd1,
	    16r6fa87e4f, 16rfe2ce6e0, 16ra3014314, 16r4e0811a1,
	    16rf7537e82, 16rbd3af235, 16r2ad7d2bb, 16reb86d391);

OP + = (BITS a, b) BITS:
   BEGIN
      BITS c = BIN (ABS (a AND 16rffff) + ABS (b AND 16rffff));
      BITS d = BIN (ABS (a SHR 16) + ABS (b SHR 16) + ABS (c SHR 16));
      (c AND 16rffff) OR (d SHL 16)
   END;

#[0:63]LONG INT k;
FOR i FROM 0 TO 63 DO
   k[i] :=  ENTIER (ABS (sin(i+1)) * LONG INT(2)**32)
OD;#

PROC md5 = (STRING intext) STRING:
   BEGIN
      # Initialize variables: #
      BITS a0 := 16r67452301,
           a1 := 16refcdab89,
           a2 := 16r98badcfe,
           a3 := 16r10325476;

      STRING text := intext;

      # Pre-processing: adding a single 1 bit #
      text +:= REPR 128;

      # Pre-processing: padding with zeros
        append "0" bit until message length in bits ≡ 448 (mod 512) #
      WHILE ELEMS text MOD 64 ≠ 56 DO
         text +:= REPR 0
      OD;

      # append original length in bits mod (2 pow 64) to message #
      text +:= dec2asc (ELEMS intext * 8);

      # MD5 rounds #
      # Process the message in successive 512-bit chunks: #
      WHILE text ≠ "" DO
	 # for each 512-bit (64 byte) chunk of message #
	 []CHAR chunk = text[1:64]; text := text[65:];
	 # break chunk into sixteen 32-bit words M[j], 0 <= j <= 15 #
	 [0:15]BITS m;
         FOR j FROM 0 TO 15 DO
             m[j] := BIN (ABS chunk[j*4+1]) OR
	             BIN (ABS chunk[j*4+2]) SHL 8 OR
	             BIN (ABS chunk[j*4+3]) SHL 16 OR
	             BIN (ABS chunk[j*4+4]) SHL 24
          OD;
          INT g;
	  BITS a, b, c, d, f, dtemp;

	  # Initialize hash value for this chunk #
	  a := a0;
          b := a1;
          c := a2;
          d := a3;
          FOR i FROM 0 TO 63 DO
             IF 0 <= i AND i <= 15 THEN
		f := (b AND c) OR ((NOT b) AND d);
		g := i
	     ELIF 16 <= i AND i <= 31 THEN
		 f := (d AND b) OR ((NOT d) AND c);
		 g := (5×i + 1) MOD 16
	     ELIF 32 <= i AND i <= 47 THEN
		 f := b XOR c XOR d;
		 g := (3×i + 5) MOD 16
	     ELIF 48 <= i AND i <= 63 THEN
		 f := c XOR (b OR (NOT d));
		 g := (7×i) MOD 16
	     FI;
	     dtemp := d;
	     d := c;
	     c := b;
	     b := b + leftrotate ((a + f + k[1+i] + m[g]), s[1+i]);
	     a := dtemp
          OD;
	  # Add this chunk's hash to result so far #
          a0 := a0 + a;
          a1 := a1 + b;
          a2 := a2 + c;
          a3 := a3 + d
       OD;
       revhex (a0) + revhex (a1) + revhex (a2) + revhex (a3)
    END;

PROC leftrotate = (BITS x, INT c) BITS:
    (x SHL c) OR (x SHR (32-c));

# dec2asc: dec to 8 byte asc #
PROC dec2asc = (INT nn)STRING:
   BEGIN
      STRING h := ""; INT n := nn;
      FOR i TO 8 DO
         h +:= REPR (n MOD 256);
         n ÷:= 256
      OD;
      h
   END;

 PROC revhex = (BITS x) STRING :
   BEGIN # Convert to lowercase hexadecimal STRING #
      PROC hexdig = (BITS x) CHAR: (REPR (ABS(x) <= 9 | ABS(x) + ABS("0") | ABS(x) - 10 + ABS("a")));
      hexdig (x SHR 4 AND 16rf) +
      hexdig (x AND 16rf) +
      hexdig (x SHR 12 AND 16rf) +
      hexdig (x SHR 8 AND 16rf) +
      hexdig (x SHR 20 AND 16rf) +
      hexdig (x SHR 16 AND 16rf) +
      hexdig (x SHR 28 AND 16rf) +
      hexdig (x SHR 24 AND 16rf)
   END;

STRING testmsg = "The quick brown fox jumps over the lazy dog";
STRING checksum = "9e107d9d372bb6826bd81d3542a419d6";

print ((testmsg, new line));
print ((checksum, new line));

STRING test = md5 (testmsg);

IF test = checksum THEN
   print (("passed", new line));
   print ((test, new line))
ELSE
   print (("failed"))
FI
