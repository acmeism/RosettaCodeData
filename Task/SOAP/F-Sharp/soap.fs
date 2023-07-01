open Microsoft.FSharp.Data.TypeProviders

type Wsdl = WsdlService<"http://example.com/soap/wsdl">
let result = Wsdl.soapFunc("hello")
let result2 = Wsdl.anotherSoapFunc(34234)
