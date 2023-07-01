<cfset Variables.myArray = [1,2,3,4,5,6,7,8,9,10]>
<cfset Variables.Product = 1>
<cfloop array="#Variables.myArray#" index="i">
 <cfset Variables.Product *= i>
</cfloop>
<cfoutput>#Variables.Product#</cfoutput>
