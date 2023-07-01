# returns the length of str                                         #
OP   LENGTH = ( STRING str )INT: ( UPB str - LWB str ) + 1;
# returns TRUE if str ends with ending FALSE otherwise              #
PRIO ENDSWITH = 9;
OP   ENDSWITH = ( STRING str, STRING ending )BOOL:
     IF  INT str length    = LENGTH str;
         INT ending length = LENGTH ending;
         ending length > str length
     THEN
         # the ending is longer than the string                     #
         FALSE
     ELSE
         # the string is at least as long as the ending             #
         str[ ( str length - ending length ) + 1 : AT 1 ] = ending
     FI # ENDSWITH # ;
# returns str cnverted to upper case                                #
OP   TOUPPER   = ( STRING str )STRING:
     BEGIN
        STRING result := str;
        FOR s pos FROM LWB result TO UPB result DO
            result[ s pos ] := to upper( result[ s pos ] )
        OD;
        result
     END # TOUPPER # ;
# tests whether file name has one of the extensions and returns     #
# the index of the extension in extensions or LWB extensions - 1    #
# if it does not end with one of the extensions                     #
# the tests are not case-sensitive                                  #
PROC has extension in list = ( STRING file name, []STRING extensions )INT:
     BEGIN
        INT    extension number := LWB extensions - 1;
        STRING upper name        = TOUPPER file name;
        FOR pos FROM LWB extensions TO UPB extensions WHILE extension number < LWB extensions DO
            IF upper name ENDSWITH ( "." + TOUPPER extensions[ pos ] )
            THEN
                # found the extension                              #
                extension number := pos
            FI
        OD;
        extension number
     END # has extension # ;
# test the has extension in list procedure                          #
PROC test has extension in list = ( STRING file name, []STRING extensions, BOOL expected result )VOID:
     IF INT extension number = has extension in list( file name, extensions );
        extension number < LWB extensions
     THEN
        # the file does not have one of the extensions              #
        print( ( file name
               , " does not have an extension in the list "
               , IF expected result THEN "NOT AS EXPECTED" ELSE "" FI
               , newline
               )
             )
     ELSE
        # the file does have one of the extensions                  #
        print( ( file name
               , " has extension """
               , extensions[ extension number ]
               , """ "
               , IF NOT expected result THEN "NOT AS EXPECTED" ELSE "" FI
               , newline
               )
             )
     FI # test has extension in list # ;
# the extensions for the task                                       #
[]STRING task extensions = ( "zip", "rar", "7z", "gz", "archive", "A##" );
# test the file names in the standard task                          #
test has extension in list( "MyData.a##",          task extensions, TRUE  );
test has extension in list( "MyData.tar.Gz",       task extensions, TRUE  );
test has extension in list( "MyData.gzip",         task extensions, FALSE );
test has extension in list( "MyData.7z.backup",    task extensions, FALSE );
test has extension in list( "MyData...",           task extensions, FALSE );
test has extension in list( "MyData",              task extensions, FALSE );
# the extensions for the extra credit                               #
[]STRING ec extensions = ( "zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2" );
# test the file names in the extra credit                           #
test has extension in list( "MyData_v1.0.tar.bz2", ec extensions,   TRUE  );
test has extension in list( "MyData_v1.0.bz2",     ec extensions,   FALSE )
