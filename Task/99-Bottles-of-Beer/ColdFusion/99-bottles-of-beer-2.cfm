<cfscript>
  for (x=99; x gte 1; x--) {
    plur = iif(x==1,'',DE('s'));
    WriteOutput("#x# bottle#plur# of beer on the wall<br>#x# bottle#plur# of beer<br>Take one down, pass it around<br>#iif(x is 1,DE('No more'),'x-1')# bottle#iif(x is 2,'',DE('s'))# of beer on the wall<br><br>");
  }
</cfscript>
