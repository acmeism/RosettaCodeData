import os, times
let accTime = getLastAccessTime("filename")
let modTime = getLastModificationTime("filename")

import posix
var unixAccTime = Timeval(tv_sec: int(accTime))
var unixModTime = Timeval(tv_sec: int(modTime))

# Set the modification time
unixModTime.tv_sec = 0

var times = [unixAccTime, unixModTime]
discard utimes("filename", addr(times))

# Set the access and modification times to the current time
discard utimes("filename", nil)
