<cffunction name="CompareInteger">
    <cfargument name="Integer1" type="numeric">
    <cfargument name="Integer2" type="numeric">
    <cfset VARIABLES.Result = "" >
    <cfif ARGUMENTS.Integer1 LT ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is less than " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfif ARGUMENTS.Integer1 LTE ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is less than or equal to " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfif ARGUMENTS.Integer1 GT ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is greater than " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfif ARGUMENTS.Integer1 GTE ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is greater than or equal to " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfif ARGUMENTS.Integer1 EQ ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is equal to " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfif ARGUMENTS.Integer1 NEQ ARGUMENTS.Integer2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is not equal to " & ARGUMENTS.Integer2 & ")" >
    </cfif>
    <cfreturn VARIABLES.Result >
</cffunction>
