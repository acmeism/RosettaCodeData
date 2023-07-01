a = {1,3,5,4,2} -- a "plain" table
table.sort(a) -- library method passing a as param
print(table.concat(a)) -- and again --> "12345"

b = {1,3,5,4,2} -- a "plain" table, so far..
setmetatable(b, {__index=table}) -- ..but now "meta-decorated"
b:sort() -- syntax sugar passes b as "self"
print(b:concat()) -- and again --> "12345"
