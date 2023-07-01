import os, strutils

let fileNameList = ["MyData.a##", "MyData.tar.Gz", "MyData.gzip",
                    "MyData.7z.backup", "MyData...", "MyData"]

func buildExtensionList(extensions: varargs[string]): seq[string] {.compileTime.} =
  for ext in extensions:
    result.add('.' & ext.toLowerAscii())

const ExtList = buildExtensionList("zip", "rar", "7z", "gz", "archive", "A##")

for fileName in fileNameList:
  echo fileName, " → ", fileName.splitFile().ext.toLowerAscii() in ExtList
