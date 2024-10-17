using LibCURL

function callSOAP(url, infilename, outfilename)
    rfp = open(infilename, "r")
    wfp = open(outfilename, "w+")

    header = curl_slist_append(header, "Content-Type:text/xml")
    header = curl_slist_append(header, "SOAPAction: rsc");
    header = curl_slist_append(header, "Transfer-Encoding: chunked")
    header = curl_slist_append(header, "Expect:")

    curl = curl_easy_init();
    curl_easy_setopt(curl, CURLOPT_URL, URL)
    curl_easy_setopt(curl, CURLOPT_POST, 1L)
    curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_data)
    curl_easy_setopt(curl, CURLOPT_READDATA, rfp)
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data)
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, wfp)
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, header)
    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE_LARGE, (curl_off_t)-1)
    curl_easy_setopt(curl, CURLOPT_VERBOSE,1L)
    curl_easy_perform(curl)

    curl_easy_cleanup(curl)
end

try
    callSOAP(ARGS[1], ARGS[2], ARGS[3])
catch y
    println("Usage : $(@__FILE__) <URL of WSDL> <Input file path> <Output File Path>")
end
