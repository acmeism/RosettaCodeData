text = "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
p2t = { [""]="N", ["."]="S", ["!"]="E", ["?"]="Q" }
for s, p in text:gmatch("%s*([^%!%?%.]+)([%!%?%.]?)") do
  print(s..p..":  "..p2t[p])
end
