function rot(l, o) return (l < 26 and l > -1) and string.char((l+13)%26 + o) end
a, A = string.byte'a', string.byte'A'
val = io.read()
val = val:gsub("(.)", function(l) return rot(l:byte()-a,a) or rot(l:byte()-A,A) or l end)
print(val)
