// Kotlin Native v0.6

import kotlinx.cinterop.*
import platform.posix.*
import libcurl.*

fun writeData(ptr: COpaquePointer?, size: size_t, nmeb: size_t, stream: COpaquePointer?)
    = fwrite(ptr, size, nmeb, stream?.reinterpret<FILE>())

fun readData(ptr: COpaquePointer?, size: size_t, nmeb: size_t, stream: COpaquePointer?)
    = fread(ptr, size, nmeb, stream?.reinterpret<FILE>())

fun callSOAP(url: String, inFile: String, outFile: String) {
    val rfp = fopen(inFile, "r")
    if (rfp == null) {
        perror("Read File Open: ")
        exit(1)
    }
    val wfp = fopen(outFile, "w+")
    if (wfp == null) {
        perror("Write File Open: ")
        fclose(rfp)
        exit(1)
    }

    var header: CPointer<curl_slist>? = null
    header = curl_slist_append (header, "Content-Type:text/xml")
    header = curl_slist_append (header, "SOAPAction: rsc")
    header = curl_slist_append (header, "Transfer-Encoding: chunked")
    header = curl_slist_append (header, "Expect:")

    val curl = curl_easy_init()
    if (curl != null) {
        curl_easy_setopt(curl, CURLOPT_URL, url)
        curl_easy_setopt(curl, CURLOPT_POST, 1L)
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, staticCFunction(::readData))
        curl_easy_setopt(curl, CURLOPT_READDATA, rfp)
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, staticCFunction(::writeData))
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, wfp)
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, header)
        curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE_LARGE, -1L)
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L)
        curl_easy_perform(curl)
        curl_easy_cleanup(curl)
    }

    curl_slist_free_all(header)
    fclose(rfp)
    fclose(wfp)
}

fun main(args: Array<String>) {
    if (args.size != 3) {
        println("You need to pass exactly 3 command line arguments, namely :-")
        println("    <URL of WSDL> <Input file path> <Output File Path>")
        return
    }
    callSOAP(args[0], args[1], args[2])
}
