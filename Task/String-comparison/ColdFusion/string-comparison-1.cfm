<cffunction name="CompareString">
    <cfargument name="String1" type="string">
    <cfargument name="String2" type="string">
    <cfset VARIABLES.Result = "" >
    <cfif ARGUMENTS.String1 LT ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is less than '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfif ARGUMENTS.String1 LTE ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is less than or equal to '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfif ARGUMENTS.String1 GT ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is greater than '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfif ARGUMENTS.String1 GTE ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is greater than or equal to '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfif ARGUMENTS.String1 EQ ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is equal to '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfif ARGUMENTS.String1 NEQ ARGUMENTS.String2 >
	    <cfset VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is not equal to '" & ARGUMENTS.String2 & "')" >
    </cfif>
    <cfreturn VARIABLES.Result >
</cffunction>
