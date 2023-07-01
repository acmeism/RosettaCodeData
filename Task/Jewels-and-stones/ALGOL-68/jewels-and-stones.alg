BEGIN
    # procedure that counts the number of times the letters in jewels occur in stones #
    PROC count jewels = ( STRING stones, jewels )INT:
         BEGIN
             # count the occurences of each letter in stones #
             INT upper a pos = 0;
             INT lower a pos = 1 + ( ABS "Z" - ABS "A" );
             [ upper a pos : lower a pos + 26 ]INT letter counts;
             FOR c FROM LWB letter counts TO UPB letter counts DO letter counts[ c ] := 0 OD;
             FOR s pos FROM LWB stones TO UPB stones DO
                 CHAR s = stones[ s pos ];
                 IF   s >= "A" AND s <= "Z" THEN letter counts[ upper a pos + ( ABS s - ABS "A" ) ] +:= 1
                 ELIF s >= "a" AND s <= "z" THEN letter counts[ lower a pos + ( ABS s - ABS "a" ) ] +:= 1
                 FI
             OD;
             # sum the counts of the letters that appear in jewels #
             INT count := 0;
             FOR j pos FROM LWB jewels TO UPB jewels DO
                 CHAR j = jewels[ j pos ];
                 IF   j >= "A" AND j <= "Z" THEN count +:= letter counts[ upper a pos + ( ABS j - ABS "A" ) ]
                 ELIF j >= "a" AND j <= "z" THEN count +:= letter counts[ lower a pos + ( ABS j - ABS "a" ) ]
                 FI
             OD;
             count
         END # count jewels # ;

    print( ( count jewels( "aAAbbbb", "aA" ), newline ) );
    print( ( count jewels( "ABCDEFGHIJKLMNOPQRSTUVWXYZ@abcdefghijklmnopqrstuvwxyz"
                         , "ABCDEFGHIJKLMNOPQRSTUVWXYZ@abcdefghijklmnopqrstuvwxyz"
                         )
           , newline
           )
         );
    print( ( count jewels( "AB", "" ), newline ) );
    print( ( count jewels( "ZZ", "z" ), newline ) )

END
