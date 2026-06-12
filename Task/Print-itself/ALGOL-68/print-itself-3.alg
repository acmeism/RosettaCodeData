BEGIN
    PR read "files.incl.a68" PR                     # include file utilities #
    STRING file name = "printItself3.a68";
    IF PRINTLINES file name < 0 THEN
        print( ( "Unable to print ", file name, newline ) )
    FI
END
