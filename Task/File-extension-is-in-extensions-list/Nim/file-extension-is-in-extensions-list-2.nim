import os, sequtils, strutils

let fileNameList = ["MyData.a##", "MyData.tar.Gz", "MyData.gzip",
                    "MyData.7z.backup", "MyData...", "MyData"]

const ExtList = mapIt(["zip", "rar", "7z", "gz", "archive", "A##"], '.' & it.toLowerAscii())

for fileName in fileNameList:
  echo fileName, " → ", fileName.splitFile().ext.toLowerAscii() in ExtList
