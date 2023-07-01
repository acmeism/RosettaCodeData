local(x = curl('https://sourceforge.net'))
local(y = #x->result)
#y->asString
