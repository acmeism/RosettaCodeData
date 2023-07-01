<cfscript>
  for( i = 1; i <= 10; i++ ) //note: the ++ notation works only on version 8 up, otherwise use i=i+1
  {
    writeOutput( i );

    if( i == 10 )
    {
      break;
    }
    writeOutput( ", " );
  }
</cfscript>
