fcoll = {} -- forward collation
sl = string.lower -- for case insensitivity
for i=0,255 do fcoll[i]=string.char(i) end -- initially just ASCII (for non-letters)
table.sort(fcoll, function(a,b) return sl(a)==sl(b) and a<b or sl(a)<sl(b) end) -- interleave upper/lower letters
rcoll = {} for i,v in ipairs(fcoll) do rcoll[v]=i end -- reverse collation

function sort(s) -- Latin letters lexicographically, uppercase first, anything else by ASCII
  local t={} s:gsub("(%S)", function(c) t[#t+1]=c end) -- use "(.)" as pattern to preserve whitespace
  table.sort(t, function(a,b) return rcoll[a]<rcoll[b] end)
  return table.concat(t)
end

print(sort("Now is the time for all good men to come to the aid of their country."))
