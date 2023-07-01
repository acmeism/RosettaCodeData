# "flips" the "bits" in a string (assumed to contain only "0" and "1" characters) #
OP  FLIP = ( STRING s )STRING:
    BEGIN
        STRING result := s;
        FOR char pos FROM LWB result TO UPB result DO
            result[ char pos ] := IF result[ char pos ] = "0" THEN "1" ELSE "0" FI
        OD;
        result
    END; # FLIP #

# print the first few members of the Thue-Morse sequence #
STRING tm := "0";
TO 7 DO
    print( ( tm, newline ) );
    tm +:= FLIP tm
OD
