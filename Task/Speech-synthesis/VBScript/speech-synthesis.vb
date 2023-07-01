Dim message, sapi
message = "This is an example of speech synthesis."
Set sapi = CreateObject("sapi.spvoice")
sapi.Speak message
