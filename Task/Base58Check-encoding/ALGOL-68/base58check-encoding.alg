BEGIN # Base58Check encoding                                              #

    PR precision 256 PR       # maximum number of digits - adjust to suit #

    # returns the LONG LONG INT n converted to a base 58 string           #
    PROC to base 58 = ( LONG LONG INT n )STRING:
         BEGIN
            STRING        base58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
            LONG LONG INT v     := n;
            STRING        r     := "";
            WHILE v > 0 DO
                base58[ 1 + SHORTEN SHORTEN ( v MOD 58 ) ] +=: r;
                v OVERAB 58
            OD;
            r
         END # to base 58 # ;

    # returns the digit sequence in v converted to base 58,               #
    #         if v begins with 0x, it is assumed to be in hex,            #
    #         otherwise it is assumed to be decimal.                      #
    #     NB: no checks that the string is valid are made                 #
    PROC string to base 58 = ( STRING v )STRING:
         BEGIN
            LONG LONG INT n    := 0;
            INT          v min := LWB v;
            INT          v max  = UPB v;
            INT          base   = IF v max - v min <= 1              THEN 10
                                  ELIF v[ v min : v min + 1 ] = "0x" THEN 16
                                  ELSE                                    10
                                  FI;
            IF base = 16 THEN v min +:= 2 FI;
            FOR v pos FROM v min TO v max DO
                n *:= base +:= IF   INT c = ABS v[ v pos ];
                                    c >= ABS "A" AND c <= ABS "F"
                               THEN c + 10 - ABS "A"
                               ELIF c >= ABS "a" AND c <= ABS "f"
                               THEN c + 10 - ABS "a"
                               ELSE c      - ABS "0"
                               FI
            OD;
            to base 58( n )
         END # string to base 58 # ;

    BEGIN
        []STRING hashes = ( "25420294593250030202636073700053352635053786165627414518"
                          , "0x61", "0x626262", "0x636363"
                          , "0x73696d706c792061206c6f6e6720737472696e67"
                          , "0x516b6fcd0f", "0xbf4f89001e670274dd"
                          , "0x572e4794", "0xecac89cad93923c02321"
                          , "0x10c8511e"
                          );
        FOR h pos FROM LWB hashes TO UPB hashes DO
            STRING h     = hashes[ h pos ];
            INT    h len = ( UPB h - LWB h ) + 1;
            STRING pad   = IF h len < 58 THEN " " * ( 58 - h len ) ELSE "" FI;
            print( ( pad, h, " -> ", string to base 58( h ), newline ) )
        OD

    END

END
