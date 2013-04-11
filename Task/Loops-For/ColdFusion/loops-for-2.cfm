<cfscript>
  for( i = 1; i <= 5; i++ )
  {
    for( j = 1; j <= i; j++ )
    {
      writeOutput( "*" );
    }
    writeOutput( "< br />" );
  }
</cfscript>
