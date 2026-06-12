function redact(text, targ, opts)
  local part, case, ovrk = opts:find("p")~=nil, opts:find("s")~=nil, opts:find("o")~=nil
  local oknp = ovrk or not part
  local patt = oknp and "([%w%-]+)" or "(%w+)"
  local ci = case and function(s) return s end or function(s) return s:lower() end
  local matches = function(s,w) return part and ci(s):find(ci(w))~=nil or ci(s)==ci(w) end
  local replace = function(s,w) return oknp and string.rep("X",#s) or ci(s):gsub(ci(w), string.rep("X",#w)) end
  return text:gsub(patt, function(word) return matches(word,targ) and replace(word,targ) or word end)
end

text = [[Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.]]
targlist, optslist = { "Tom", "tom" }, { "[w|s|n]", "[w|i|n]", "[p|s|n]", "[p|i|n]", "[p|s|o]", "[p|i|o]" }
for _,targ in ipairs(targlist) do
  print("Redact '"..targ.."':")
  for _,opts in ipairs(optslist) do
    print(opts .. " " .. redact(text, targ, opts))
  end
end
