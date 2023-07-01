import soap

procedure main(A)
    soap := SoapClient(A[1] | "http://example.com/soap/wsdl")  # Allow override of default
    write("soapFunc: ",soap.call("soapFunc"))
    write("anotherSoapFunc: ",soap.call("anotherSoapFunc"))
end
