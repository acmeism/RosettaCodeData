# Using the "e" command.

import std/os

const TempFile = "/tmp/hello.nim"
const Program = """echo "Hello World!""""

# Write program into temporary file.
let outFile = open(TempFile, fmWrite)
outFile.writeLine Program
outFile.close()

# Lauch "nim" to execute the program.
# "--hints:off" suppresses the hint messages.
discard execShellCmd("nim e --hints:off " & TempFile)

# Remove temporary file.
removeFile(TempFile)
