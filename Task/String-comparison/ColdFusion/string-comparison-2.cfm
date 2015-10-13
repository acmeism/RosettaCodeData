<cfscript>
	function CompareString( String1, String2 ) {
		VARIABLES.Result = "";
		if ( ARGUMENTS.String1 LT ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is less than '" & ARGUMENTS.String2 & "')";
		}
		if ( ARGUMENTS.String1 LTE ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is less than or equal to '" & ARGUMENTS.String2 & "')";
		}
		if ( ARGUMENTS.String1 GT ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is greater than '" & ARGUMENTS.String2 & "')";
		}
		if ( ARGUMENTS.String1 GTE ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is greater than or equal to '" & ARGUMENTS.String2 & "')";
		}
		if ( ARGUMENTS.String1 EQ ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is equal to '" & ARGUMENTS.String2 & "')";
		}
		if ( ARGUMENTS.String1 NEQ ARGUMENTS.String2 ) {
			VARIABLES.Result = VARIABLES.Result & "('" & ARGUMENTS.String1 & "' is not equal to '" & ARGUMENTS.String2 & "')";
		}
		return VARIABLES.Result;
	}
</cfscript>
