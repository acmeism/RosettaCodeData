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

<cffunction name="ethiopian">
    <cfargument name="Number_A" type="numeric" required="true">
    <cfargument name="Number_B" type="numeric" required="true">
    <cfset Result = 0>

    <cfloop condition = "Number_A GTE 1">
        <cfif even(Number_A) EQ 1>
            <cfset Result = Result + Number_B>
        </cfif>
        <cfset Number_A = halve(Number_A)>
        <cfset Number_B = double(Number_B)>
    </cfloop>
    <cfreturn Result>
</cffunction>


<cfoutput>#ethiopian(17,34)#</cfoutput>
