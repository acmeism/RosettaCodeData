Split_Change(str){
	return RegExReplace(str, "(.)\1*(?!$)", "$0, ")
}
