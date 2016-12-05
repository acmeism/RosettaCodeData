# returns TRUE if the specified directory is empty, FALSE if it doesn't exist or is non-empty #
PROC is empty directory = ( STRING directory )BOOL:
     IF NOT file is directory( directory )
     THEN
         # directory doesn't exist #
         FALSE
     ELSE
         # directory is empty if it contains no files or just "." and possibly ".." #
         []STRING files   = get directory( directory );
         BOOL     result := FALSE;
         FOR f FROM LWB files TO UPB files
         WHILE result := files[ f ] = "." OR files[ f ] = ".."
         DO
             SKIP
         OD;
         result
     FI # is empty directory # ;

# test the is empty directory procedure #
# show whether the directories specified on the command line ( following "-" ) are empty or not #
BOOL directory name parameter := FALSE;
FOR i TO argc DO
    IF argv( i ) = "-"
    THEN
        # marker to indicate directory names follow #
        directory name parameter := TRUE
    ELIF directory name parameter
    THEN
        # have a directory name - report whether it is emty or not #
        print( ( argv( i ), " is ", IF is empty directory( argv( i ) ) THEN "empty" ELSE "not empty" FI, newline ) )
    FI
OD
