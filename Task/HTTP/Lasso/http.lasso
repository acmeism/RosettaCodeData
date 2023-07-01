// using include_url wrapper:
include_url('http://rosettacode.org/index.html')

// one line curl
curl('http://rosettacode.org/index')->result->asString

// using curl for more complex operations and feedback
local(x = curl('http://rosettacode.org/index'))
local(y = #x->result)
#y->asString
