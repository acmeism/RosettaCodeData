function isValidIdentifier(id)
  local reserved = {
    ["and"]=true, ["break"]=true, ["do"]=true, ["end"]=true, ["else"]=true, ["elseif"]=true, ["end"]=true,
    ["false"]=true, ["for"]=true, ["function"]=true, ["goto"]=true, ["if"]=true, ["in"]=true,
    ["local"]=true, ["nil"]=true, ["not"]=true, ["or"]=true, ["repeat"]=true, ["return"]=true,
    ["then"]=true, ["true"]=true, ["until"]=true, ["while"]=true }
  return id:find("^[a-zA-Z_][a-zA-Z0-9_]*$") ~= nil and not reserved[id]
end
vfc, vsc = {}, {}
for i = 0, 255 do
  local c = string.char(i)
  if isValidIdentifier(c) then vfc[#vfc+1]=c end
  if isValidIdentifier("_"..c) then vsc[#vsc+1]=c end
end
print("Valid First Characters:  " .. table.concat(vfc))
print("Valid Subsequent Characters:  " .. table.concat(vsc))
