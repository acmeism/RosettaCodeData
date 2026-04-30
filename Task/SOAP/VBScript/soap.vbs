Dim client
Dim result
Set client = CreateObject("MSSOAP.SoapClient")
client.MSSoapInit "http://example.com/soap/wsdl"
result = client.soapFunc("hello")
result = client.anotherSoapFunc(34234)
