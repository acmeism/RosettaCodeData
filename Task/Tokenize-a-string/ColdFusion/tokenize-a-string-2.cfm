<cfscript>
  wordList = "Hello,How,Are,You,Today";
  splitList = replace( wordList, ",", ".", "all" );
  writeOutput( splitList );
</cfscript>
