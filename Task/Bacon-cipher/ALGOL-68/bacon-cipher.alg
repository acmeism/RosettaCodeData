# Bacon's letter codes but with distinct values for i & j and u & v and an extra for any non-letter #
[]STRING bacon codes = ( #a# "AAAAA", "AAAAB", "AAABA", "AAABB", "AABAA", "AABAB", "AABBA", "AABBB", "ABAAA"
                       , #j# "ABAAB", "ABABA", "ABABB", "ABBAA", "ABBAB", "ABBBA", "ABBBB", "BAAAA", "BAAAB"
                       , #s# "BAABA", "BAABB", "BABAA", "BABAB", "BABBA", "BABBB", "BBAAA", "BBAAB", "BBBAA"
                       );
# operators to convert case #
OP LCASE = ( CHAR c )CHAR: IF c < "A" OR c > "Z" THEN c ELSE REPR ( ( ABS c - ABS "A" ) + ABS "a" ) FI;
OP UCASE = ( CHAR c )CHAR: IF c < "a" OR c > "z" THEN c ELSE REPR ( ( ABS c - ABS "a" ) + ABS "A" ) FI;
# yields plain text encoded via stego template #
PROC to bacon = ( STRING plain text, STRING stego template )STRING:
     BEGIN
         INT    stego pos   := 0;
         INT    stego len    = ( UPB stego template + 1 ) - LWB stego template;
         INT    stego start  = LWB stego template;
         # selects the next character from the stego template - wraps-around from the end to the beginning #
         PROC next stego pos = VOID: ( stego pos +:= 1; stego pos MODAB stego len);
         # encode the plain text #
         STRING encoded     := "";
         FOR pos FROM LWB plain text TO UPB plain text DO
             # get the Bacon code of the next character #
             CHAR   plain char = UCASE plain text[ pos ];
             STRING code = bacon codes[ IF   plain char < "A" OR plain char > "Z"
                                        THEN UPB bacon codes
                                        ELSE ( ABS plain char - ABS "A" ) + 1
                                        FI
                                      ];
             FOR c FROM LWB code TO UPB code DO
                 # copy punctuation as is from the stego template to the result #
                 WHILE CHAR s := UCASE stego template[ stego pos + stego start ];
                       s < "A" OR s > "Z"
                 DO
                     encoded   +:= s;
                     next stego pos
                 OD;
                 # encode the character by changing the case of the stego character as appropriate #
                 CHAR template char = stego template[ stego pos + stego start ];
                 encoded +:= IF code[ c ] = "A" THEN LCASE template char ELSE UCASE template char FI;
                 next stego pos
             OD
         OD;
         encoded
     END ; # to bacon #
# yields bacon text decoded via stego template #
PROC to plain = ( STRING bacon text, stego template )STRING:
     BEGIN
         STRING decoded := "";
         INT coded char := 0;
         INT letters    := 0;
         INT code length = ( UPB bacon codes[ 1 ] - LWB bacon codes[ 1 ] ) + 1;
         FOR pos FROM LWB bacon text TO UPB bacon text DO
             CHAR c = bacon text[ pos ];
             IF c >= "a" AND c <= "z"
             THEN
                 # lower case letter #
                 coded char *:= 2;
                 letters    +:= 1
             ELIF c >= "A" AND c <= "Z"
             THEN
                 # upper case letter #
                 coded char *:= 2;
                 coded char +:= 1;
                 letters    +:= 1
             FI;
             IF letters = code length
             THEN
                 # have a full letter to decode #
                 decoded    +:= IF coded char > 25 THEN " " ELSE REPR ( ABS "a" + coded char ) FI;
                 letters     := 0;
                 coded char  := 0
             FI
         OD;
         decoded
     END ; # to plain #
BEGIN # test encode and decode #
    STRING test template
         = "bacon's cipher is a method of steganography created by francis bacon."
         + REPR 10
         + "this task is to implement a program for encryption and decryption of "
         + REPR 10
         + "plaintext using the simple alphabet of the baconian cipher or some "
         + REPR 10
         + "other kind of representation of this alphabet (make anything signify anything). "
         + REPR 10
         + "the baconian alphabet may optionally be extended to encode all lower "
         + REPR 10
         + "case characters individually and/or adding a few punctuation characters "
         + REPR 10
         + "such as the space."
         + REPR 10
         ;
    STRING plain text    = "the quick brown fox jumps over the lazy dog";
    STRING bacon encoded = to bacon( plain text,    test template );
    STRING bacon decoded = to plain( bacon encoded, test template );
    print( ( "encoded...", newline ) );
    print( ( bacon encoded, newline ) );
    print( ( "-----------------------------------------------------", newline ) );
    print( ( "decoded...", newline ) );
    print( ( bacon decoded, newline ) );
    print( ( "-----------------------------------------------------", newline ) );
    print( ( IF bacon decoded /= plain text THEN "UNSUCESSFUL" ELSE "sucessful" FI
           , " decode", newline
           )
         )
END
