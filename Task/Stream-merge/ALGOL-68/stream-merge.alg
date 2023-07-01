# merge a number of input files to an output file                             #
PROC mergenf = ( []REF FILE inf, REF FILE out )VOID:
     BEGIN
        INT        eof count := 0;
        BOOL       at eof    := FALSE;
        []REF FILE inputs     = inf[ AT 1 ];
        INT   number of files = UPB inputs;
        [ number of files ]BOOL eof;
        [ number of files ]STRING line;
        FOR f TO number of files DO
            eof[ f ] := FALSE;
            on logical file end( inf[ f ], ( REF FILE f )BOOL:
                                           BEGIN
                                               # note that we reached EOF on the latest read #
                                               # and return TRUE so processing can continue #
                                               at eof := TRUE
                                           END
                               )
        OD;
        # read a line from one of the input files                              #
        PROC read line = ( INT file number )VOID:
             BEGIN
                 at eof := FALSE;
                 get( inputs[ file number ], ( line[ file number ], newline ) );
                 eof[ file number ] := at eof;
                 IF at eof THEN
                     # reached eof on this file                                #
                     eof count +:= 1
                 FI
             END; # read line #
        # get the first line from each input file                              #
        FOR f TO number of files DO read line( f ) OD;
        # merge the files                                                      #
        WHILE eof count < number of files DO
            # find the lowest line in the current set                          #
            INT    low pos     := 0;
            STRING low line    := "";
            BOOL   first file  := TRUE;
            FOR file pos TO number of files DO
                IF eof[ file pos ] THEN
                    # file is at eof - ignore it                               #
                    SKIP
                ELIF first file THEN
                    # this is the first file not at eof                        #
                    low pos    := file pos;
                    low line   := line[ file pos ];
                    first file := FALSE
                ELIF line[ file pos ] < low line THEN
                    # this line is lower than the previous one                 #
                    low pos    := file pos;
                    low line   := line[ file pos ]
                FI
            OD;
            # write the record from the lowest file and get the next record    #
            # from it                                                          #
            put( out, ( line[ low pos ], newline ) );
            read line( low pos )
        OD
     END; # mergenf #

# merges the files named in input list, the results are written to the file     #
# named output name                                                             #
# the output file must already exist and will be overwritten                    #
PROC mergen = ( []STRING input list, STRING output name )VOID:
     BEGIN
        []STRING inputs       = input list[ AT 1 ];
        INT number of files   = UPB inputs;
        [ number of files ]REF FILE inf;
        # open the input files                                                  #
        FOR f TO number of files DO
             inf[ f ] := LOC FILE;
             IF  open( inf[ f ], inputs[ f ], stand in channel ) /= 0
             THEN
                 # failed to open the input file #
                 print( (  "Unable to open """ + input list[ f ] + """", newline ) );
                 stop
             FI
        OD;
        # open the output file (which must already exist & will be overwritten) #
        IF FILE output file;
           open( output file, output name, stand out channel ) /= 0
        THEN
            # failed to open the output file #
            print( (  "Unable to open """ + output name + """", newline ) );
            stop
        ELSE
            # files opened OK, merge them #
            mergenf( inf, output file );
            # close the files #
            close( output file );
            FOR f TO number of files DO close( inf[ f ] ) OD
        FI
     END; # mergen #

# merges the two files in1 and in2 to output file #
PROC merge2f = ( REF FILE in1, REF FILE in2, REF FILE output file )VOID: mergenf( ( in1, in2 ), output file );

# merges the two files named in1 and in2 to the file named output file #
PROC merge2 = ( STRING in1, STRING in2, STRING output file )VOID: mergen( ( in1, in2 ), output file );

# test the file merge #
merge2(   "in1.txt", "in2.txt",                         "out2.txt" );
mergen( ( "in1.txt", "in2.txt", "in3.txt", "in4.txt" ), "outn.txt" )
