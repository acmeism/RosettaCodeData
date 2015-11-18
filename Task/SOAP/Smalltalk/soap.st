| service client response1 response2 |

service := SprayWSDLService onUrl: 'http://example.com/soap/wsdl'.

client := service createClient.
response1 := client send: 'soapFunc' withArguments:{ 'hello' }.
response2 := client send: 'anotherSoapFunc' withArguments:{ 34234 }.
