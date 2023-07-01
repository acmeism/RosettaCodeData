macLookup(MAC){
	WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WebRequest.Open("GET", "http://api.macvendors.com/" MAC)
	WebRequest.Send()
	return WebRequest.ResponseText
}
