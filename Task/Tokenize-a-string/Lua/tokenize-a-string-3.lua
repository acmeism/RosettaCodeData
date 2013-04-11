str = "Hello|How|Are|You||Today"

tokens = {}
for w in string.gmatch( str, "([^|]*)|?" ) do
    tokens[#tokens+1] = w
end
table.remove(tokens)--pops off the last empty value, because without doing |? we lose the last element.

for i = 1, #tokens do
    print( tokens[i] )
end
