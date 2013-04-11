str = "Hello,How,Are,You,Today"

tokens = {}
for w in string.gmatch( str, "(%a+)" ) do
    tokens[#tokens+1] = w
end

for i = 1, #tokens do
    print( tokens[i] )
end
