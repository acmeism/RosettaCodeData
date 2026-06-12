MODE INPUTRECORD     = STRUCT( STRING field a, STRING field b, INT field c, CHAR sign of field c, STRING field d );
MODE OUTPUTRECORD    = STRUCT( STRING field a,                 INT field c,                       STRING field x );

FORMAT input format  = $ 5a, 5a,   4d, 1a, 5a l $;
FORMAT output format = $ 5a,     3z-d,     5a l $;

IF  FILE input file;
    STRING file name = "input.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( (  "Unable to open """ + file name + """", newline ) )
ELIF FILE output file;
     STRING output name = "output.txt";
     open( output file, output name, stand out channel ) /= 0
THEN
    # failed to open the otput file #
    print( (  "Unable to open """ + output name + """", newline ) );
    close( input file )
ELSE
    # files opened OK #
    BOOL at eof := FALSE;
    # set the EOF handler for the file #
    on logical file end( input file, ( REF FILE f )BOOL:
                                     BEGIN
                                         # note that we reached EOF on the #
                                         # latest read #
                                         at eof := TRUE;
                                         # return TRUE so processing can continue #
                                         TRUE
                                     END
                       );
    WHILE INPUTRECORD in record;
          getf( input file, ( input format,  in record ) );
          NOT at eof
    DO
        IF sign of field c OF in record = "-" THEN field c OF in record *:= -1 FI;
        OUTPUTRECORD out record;
        field a OF out record := field a OF in record;
        field c OF out record := field c OF in record;
        field x OF out record := "XXXXX";
        putf( output file, ( output format, out record ) )
    OD;
    # close the file #
    close( output file );
    close( input file  )
FI
