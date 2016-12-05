import posix
const size = 64
var s = cstring(newString(size))
discard s.getHostname(size)
echo s
