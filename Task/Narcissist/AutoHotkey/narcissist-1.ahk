Narcissist(Input) {
	FileRead, Source, % A_ScriptFullPath
	return Input == Source ? "accept" : "reject"
}
