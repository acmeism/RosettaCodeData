<cfoutput>
  <cfloop index="x" from="99" to="0" step="-1">
    <cfset plur = iif(x is 1,"",DE("s"))>
    #x# bottle#plur# of beer on the wall<br>
    #x# bottle#plur# of beer<br>
    Take one down, pass it around<br>
    #iif(x is 1,DE("No more"),"x-1")# bottle#iif(x is 2,"",DE("s"))# of beer on the wall<br><br>
  </cfloop>
</cfoutput>
