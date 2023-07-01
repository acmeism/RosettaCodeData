<cfscript>
  // Date Time
  currentTime = Now();
  writeOutput( currentTime );

  // Epoch
  // Credit for Epoch time should go to Ben Nadel
  // bennadel.com is his blog
  utcDate = dateConvert( "local2utc", currentTime );
  writeOutput( utcDate.getTime() );
</cfscript>
