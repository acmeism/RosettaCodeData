<cfset Number_A = 17>
<cfset Number_B = 34>
<cfset Result = 0>

<cffunction name="double">
    <cfargument name="number" type="numeric" required="true">
	<cfset answer = number * 2>
    <cfreturn answer>
</cffunction>

<cffunction name="halve">
    <cfargument name="number" type="numeric" required="true">
	<cfset answer = int(number / 2)>
    <cfreturn answer>
</cffunction>

<cffunction name="even">
    <cfargument name="number" type="numeric" required="true">
	<cfset answer = number mod 2>
    <cfreturn answer>
</cffunction>


<cfoutput>

Ethiopian multiplication of #Number_A# and #Number_B#...
<br>


<table width="512" border="0" cellspacing="20" cellpadding="0">

<cfloop condition = "Number_A GTE 1">


   <cfif even(Number_A) EQ 1>
   	<cfset Result = Result + Number_B>
        <cfset Action = "Keep">
   <cfelse>
	<cfset Action = "Strike">
   </cfif>

  <tr>
    <td align="right">#Number_A#</td>
    <td align="right">#Number_B#</td>
    <td align="center">#Action#</td>
  </tr>

  <cfset Number_A = halve(Number_A)>
  <cfset Number_B = double(Number_B)>

</cfloop>

</table>

...equals #Result#

</cfoutput>
