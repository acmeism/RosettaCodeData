a=array("00-20-6b-ba-d0-cb","00-40-ae-04-87-86")
set WebRequest = CreateObject("WinHttp.WinHttpRequest.5.1")

for each MAC in a
  if b<>0 then   wscript.echo "Spacing next request...": wscript.sleep 2000
  WebRequest.Open "GET", "http://api.macvendors.com/"& mac,1
  WebRequest.Send()
  WebRequest.WaitForResponse
  b=b+1
  wscript.echo mac & " -> " & WebRequest.ResponseText
next
