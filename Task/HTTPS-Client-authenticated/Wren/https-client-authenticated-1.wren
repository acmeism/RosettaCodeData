/* https_client-authenticated.wren */

var CURLOPT_URL       = 10002
var CURLOPT_SSLCERT   = 10025
var CURLOPT_SSLKEY    = 10087
var CURLOPT_KEYPASSWD = 10258

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

curl.easySetOpt(CURLOPT_URL, "https://example.com/")
curl.easySetOpt(CURLOPT_SSLCERT, "cert.pem")
curl.easySetOpt(CURLOPT_SSLKEY, "key.pem")
curl.easySetOpt(CURLOPT_KEYPASSWD, "s3cret")

var status = curl.easyPerform()
if (status != 0) {
    System.print("Failed to perform task.")
    return
}
curl.easyCleanup()
