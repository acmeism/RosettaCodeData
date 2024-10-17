BEGIN
  # note the pathnames and commands are Windows specific - adjust for other systems #
  STRING root = "\", del  = "del ", rmdir = "rmdir ";
  PROC remove file = (STRING file name)INT: system( del  + file name );
  PROC remove dir  = (STRING file name)INT: system(rmdir + file name );
  PROC report error = ( STRING message )VOID: print( ( message, newline ) );
  IF remove file("input.txt")        NE 0 THEN report error( "Unable to remove input.txt"  ) FI;
  IF remove file(root + "input.txt") NE 0 THEN report error( "Unable to remove " + root + "input.txt" ) FI;
  IF remove dir("docs")              NE 0 THEN report error( "Unable to remove docs" ) FI;
  IF remove dir(root + "docs")       NE 0 THEN report error( "Unable to remove " + root + "docs" ) FI
END
