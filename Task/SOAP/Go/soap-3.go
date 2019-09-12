import soap

procedure main()
    server := SoapServer("http://example.com/soap/wsdl")
    server.addService("soapFunc",   soapFunc)
    server.addService("anotherSoapFunc", anotherSoapFunc)
    msg := server.handleRequest()
    write(msg)
    exit(0)
end

procedure soapFunc(A[])
    every (s := " ") ||:= (!A || " ")
    return "Hello" || s[1:-1]
end

procedure anotherSoapFunc(A[])
    every (s := " ") ||:= (!A || " ")
    return "Goodbye" || s[1:-1]
end
