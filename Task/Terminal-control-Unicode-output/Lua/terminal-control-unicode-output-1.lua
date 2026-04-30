local H = io.popen"stty"
local isutf8 = H and H:read"a":find"iutf8"
H:close()

print(
 isutf8 and "Terminal handles unicode and U+25B3 is: \u{25b3}"
 or "Terminal does not support utf8"
)
