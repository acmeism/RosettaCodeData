print("Enter a multi-line story (finish with blank line):")
dict, story, line = {}, "", io.read()
while #line>0 do story=story..line.."\n" line=io.read() end
story = story:gsub("(%<.-%>)", function(what)
  if dict[what] then return dict[what] end
  io.write("Please enter a " .. what .. ":  ")
  dict[what] = io.read()
  return dict[what]
  end)
print("\n"..story)
