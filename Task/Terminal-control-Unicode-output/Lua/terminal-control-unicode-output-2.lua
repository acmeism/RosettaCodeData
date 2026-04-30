local isterm, isutf8term
local Run = function (cmd)
 local H = io.popen(cmd) local S = H and H:read"a" H:close()
 return S or ""
end
local posix = require"posix"
if posix then
 isterm = posix.isatty(0)==1
else
 local S = Run"tty"
 isterm = S:find"tty" or S:find"pts"
end

if isterm or isterm==nil then
 local stty= Run"stty"
 isutf8term = Run"stty":find"iutf8"
end

print(
 isutf8term and "Terminal handles unicode and U+25B3 is: \u{25b3}"
 or isterm and "Terminal does not support utf8"
 or "Not a terminal"
)
