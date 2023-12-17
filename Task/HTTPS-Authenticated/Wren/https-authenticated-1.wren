/* HTTPS_Authenticated.wren */

var CURLOPT_URL = 10002
var CURLOPT_FOLLOWLOCATION = 52
var CURLOPT_ERRORBUFFER = 10010

foreign class Curl {
    construct easyInit() {}

    foreign easySetOpt(opt, param)

    foreign easyPerform()

    foreign easyCleanup()
}

var curl = Curl.easyInit()
if (curl == 0) {
    System.print("Error initializing cURL.")
    return
}
curl.easySetOpt(CURLOPT_URL, "https://user:password@secure.example.com/")
curl.easySetOpt(CURLOPT_FOLLOWLOCATION, 1)
curl.easySetOpt(CURLOPT_ERRORBUFFER, 0) // buffer to be supplied by C

var status = curl.easyPerform()
if (status != 0) {
    System.print("Failed to perform task.")
    return
}
curl.easyCleanup()
