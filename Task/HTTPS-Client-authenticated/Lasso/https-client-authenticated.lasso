local(sslcert = file('myCert.pem'))
local(x = curl('https://sourceforge.net'))
#x->set(CURLOPT_SSLCERT, #sslcert->readstring)
#sslcert->close
#x->result->asString
