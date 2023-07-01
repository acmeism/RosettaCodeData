bc = require("bc")
-- since 5$=5^4$, and IEEE754 can handle 4$, this would be sufficient:
-- n = bc.pow(bc.new(5), bc.new(4^3^2))
-- but for this task:
n = bc.pow(bc.new(5), bc.pow(bc.new(4), bc.pow(bc.new(3), bc.new(2))))
s = n:tostring()
print(string.format("%s...%s (%d digits)", s:sub(1,20), s:sub(-20,-1), #s))
