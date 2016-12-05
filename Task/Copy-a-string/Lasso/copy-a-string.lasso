local(x = 'I saw a rhino!')
local(y = #x)

#x //I saw a rhino!
'\r'
#y //I saw a rhino!

'\r\r'
#x = 'I saw one too'
#x //I saw one too
'\r'
#y //I saw a rhino!

'\r\r'
#y = 'it was grey.'
#x //I saw one too
'\r'
#y //it was grey.
