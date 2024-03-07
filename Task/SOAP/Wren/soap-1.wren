/* SOAP.wren */

var CURLOPT_URL = 10002
var CURLOPT_POST = 47
var CURLOPT_READFUNCTION = 20012
var CURLOPT_READDATA = 10009
var CURLOPT_WRITEFUNCTION = 20011
var CURLOPT_WRITEDATA = 10001
var CURLOPT_HTTPHEADER = 10023
var CURLOPT_POSTFIELDSIZE_LARGE = 30120
var CURLOPT_VERBOSE = 41

foreign class File {
    foreign static url

    foreign static readFile

    foreign static writeFile

    construct open(filename, mode) {}
}

foreign class CurlSlist {
    construct new() {}

    foreign append(s)
}

foreign class Curl {
    construct easyInit() {}

    foreign easySetOpt(opt, param)

    foreign easyPerform()

    foreign easyCleanup()
}

var soap = Fn.new { |url, inFile, outFile|
    var rfp = File.open(inFile, "r")
    if (rfp == 0) Fiber.abort("Error opening read file.")
    var wfp = File.open(outFile, "w+")
    if (wfp == 0) Fiber.abort("Error opening write file.")

    var header = CurlSlist.new()
    header = header.append("Content-Type:text/xml")
    header = header.append("SOAPAction: rsc")
    header = header.append("Transfer-Encoding: chunked")
    header = header.append("Expect:")

    var curl = Curl.easyInit()
    if (curl == 0) Fiber.abort("Error initializing cURL.")
    curl.easySetOpt(CURLOPT_URL, url)
    curl.easySetOpt(CURLOPT_POST, 1)
    curl.easySetOpt(CURLOPT_READFUNCTION, 0)  // read function to be supplied by C
    curl.easySetOpt(CURLOPT_READDATA, rfp)
    curl.easySetOpt(CURLOPT_WRITEFUNCTION, 0) // write function to be supplied by C
    curl.easySetOpt(CURLOPT_WRITEDATA, wfp)
    curl.easySetOpt(CURLOPT_HTTPHEADER, header)
    curl.easySetOpt(CURLOPT_POSTFIELDSIZE_LARGE, -1)
    curl.easySetOpt(CURLOPT_VERBOSE, 1)

    curl.easyPerform()
    curl.easyCleanup()
}

soap.call(File.url, File.readFile, File.writeFile)
