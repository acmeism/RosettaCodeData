<cfscript>
	function CompareInteger( Integer1, Integer2 ) {
		VARIABLES.Result = "";
		if ( ARGUMENTS.Integer1 LT ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is less than " & ARGUMENTS.Integer2 & ")";
		}
		if ( ARGUMENTS.Integer1 LTE ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is less than or equal to " & ARGUMENTS.Integer2 & ")";
		}
		if ( ARGUMENTS.Integer1 GT ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is greater than " & ARGUMENTS.Integer2 & ")";
		}
		if ( ARGUMENTS.Integer1 GTE ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is greater than or equal to " & ARGUMENTS.Integer2 & ")";
		}
		if ( ARGUMENTS.Integer1 EQ ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is equal to " & ARGUMENTS.Integer2 & ")";
		}
		if ( ARGUMENTS.Integer1 NEQ ARGUMENTS.Integer2 ) {
			VARIABLES.Result = VARIABLES.Result & "(" & ARGUMENTS.Integer1 & " is not equal to " & ARGUMENTS.Integer2 & ")";
		}
		return VARIABLES.Result;
	}
</cfscript>
