import std/[os, tempfiles]

let (file, path) = createTempFile(prefix = "", suffix = "")
echo path, " created."
file.writeLine("This is a secure temporary file.")
file.close()
for line in path.lines:
  echo line
removeFile(path)
