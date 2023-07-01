import os, strutils, times

if paramCount() == 0: quit(QuitSuccess)
let fileName = paramStr(1)

# Get and display last modification time.
var mtime = fileName.getLastModificationTime()
echo "File \"$1\" last modification time: $2".format(fileName, mtime.format("YYYY-MM-dd HH:mm:ss"))

# Change last modification time to current time.
fileName.setLastModificationTime(now().toTime())
