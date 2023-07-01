local d, digits, alpha = '01230120022455012623010202', {}, ('A'):byte()
d:gsub(".",function(c)
  digits[string.char(alpha)] = c
  alpha = alpha + 1
end)

function soundex(w)
  local res = {}
  for c in w:upper():gmatch'.'do
    local d = digits[c]
    if d then
      if #res==0 then
        res[1] =  c
      elseif #res==1 or d~= res[#res] then
        res[1+#res] = d
      end
    end
  end
  if #res == 0 then
    return '0000'
  else
    res = table.concat(res):gsub("0",'')
    return (res .. '0000'):sub(1,4)
  end
end

-- tests
local tests = {
  {"",         "0000"}, {"12346",     "0000"},
  {"he",       "H000"}, {"soundex",   "S532"},
  {"example",  "E251"}, {"ciondecks", "C532"},
  {"ekzampul", "E251"}, {"rÃ©sumÃ©",  "R250"},
  {"Robert",   "R163"}, {"Rupert",    "R163"},
  {"Rubin",    "R150"}, {"Ashcraft",  "A226"},
  {"Ashcroft", "A226"}
}

for i=1,#tests do
  local itm = tests[i]
  assert( soundex(itm[1])==itm[2] )
end
print"all tests ok"
