local(username = 'hello',password = 'world')
local(x = curl('https://sourceforge.net'))
#x->set(CURLOPT_USERPWD, #username + ':' + #password)
local(y = #x->result)
#y->asString
