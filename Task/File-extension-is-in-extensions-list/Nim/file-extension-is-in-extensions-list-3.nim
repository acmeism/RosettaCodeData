import strutils, sequtils

let fileNameList = ["MyData.a##", "MyData.tar.Gz", "MyData.gzip",
                    "MyData.7z.backup", "MyData...", "MyData",
                    "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2"]

const ExtList = mapIt(["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"], '.' & it.toLowerAscii())

for fileName in fileNameList:
  echo fileName, " → ", ExtList.anyIt(fileName.toLowerAscii().endsWith(it))
