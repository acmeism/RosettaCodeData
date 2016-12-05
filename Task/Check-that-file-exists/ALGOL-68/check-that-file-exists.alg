# Check files and directories exist                               #

# check a file exists by attempting to open it for input          #
# returns TRUE if the file exists, FALSE otherwise                #
PROC file exists = ( STRING file name )BOOL:
    IF  FILE f;
        open( f, file name, stand in channel ) = 0
    THEN
        # file opened OK so must exist                            #
        close( f );
        TRUE
    ELSE
        # file cannot be opened - assume it does not exist        #
        FALSE
    FI # file exists # ;

# print a suitable messages if the specified file exists          #
PROC test file exists = ( STRING name )VOID:
    print( ( "file: "
           , name
           , IF file exists( name ) THEN " does" ELSE " does not" FI
           , " exist"
           , newline
           )
         );
# print a suitable messages if the specified directory exists     #
PROC test directory exists = ( STRING name )VOID:
    print( ( "dir:  "
           , name
           , IF file is directory( name ) THEN " does" ELSE " does not" FI
           , " exist"
           , newline
           )
         );

# test the flies and directories mentioned in the task exist or not #
test file exists( "input.txt" );
test file exists( "\input.txt");
test directory exists( "docs" );
test directory exists( "\docs" )
