# extracts a file-extension from the end of a pathname. The file extension is #
# defined as a dot followed by one or more letters or digits                  #
OP  EXTENSION = ( STRING pathname )STRING:
    IF LWB pathname >= UPB pathname THEN
        # the pathname has 0 or 1 characters and so has no extension          #
        ""
    ELIF NOT isalnum( pathname[ UPB pathname ] ) THEN
        # the final character is not a letter or digit - no extension         #
        ""
    ELSE
        # could have an extension                                             #
        INT    pos := UPB pathname;
        WHILE pos > LWB pathname AND isalnum( pathname[ pos ] ) DO
            pos -:= 1
        OD;
        IF pathname[ pos ] = "." THEN
            # the character before the letters and digits was a "."           #
            pathname[ pos : ]
        ELSE
            # no "." before the letters and digits - no extension             #
            ""
        FI
    FI ; # EXTENSION #

# test the EXTENSION operator                                                 #
PROC test extension = ( STRING pathname, STRING expected extension )VOID:
    BEGIN
        STRING extension = EXTENSION pathname;
        write( ( ( pathname
                 + " got extension: ("
                 + extension
                 + ") "
                 + IF extension = expected extension THEN "" ELSE "NOT" FI
                 + " as expected"
                 )
               , newline
               )
             )
    END ; # text extension #


BEGIN test extension( "http://example.com/download.tar.gz", ".gz"      )
    ; test extension( "CharacterModel.3DS",                 ".3DS"     )
    ; test extension( ".desktop",                           ".desktop" )
    ; test extension( "document",                           ""         )
    ; test extension( "document.txt_backup",                ""         )
    ; test extension( "/etc/pam.d/login",                   ""         )
END
