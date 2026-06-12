function sort(s) -- Latin letters lexicographically, uppercase first, anything else by ASCII
  local sl,t=string.lower,{} s:gsub("(%S)", function(c) t[#t+1]=c end) -- use "(.)" as pattern to preserve whitespace
  table.sort(t, function(a,b) return sl(a)==sl(b) and a<b or sl(a)<sl(b) end) -- implicitly
  return table.concat(t)
end

print(sort("Now is the time for all good men to come to the aid of their country."))
