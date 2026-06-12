import os

let execFile = getAppFilename()
let sourceFile = execFile.addFileExt("nim")
stdout.write sourceFile.readFile()
