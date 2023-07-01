define swap(a, b) => (: #b, #a)

local(a) = 'foo'
local(b) = 42

local(a,b) = swap(#a, #b)
stdoutnl(#a)
stdoutnl(#b)
