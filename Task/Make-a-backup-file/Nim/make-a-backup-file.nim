import os, strutils

const
  Suffix = ".backup"
  Dir = "working_dir"
  SubDir = "dir"
  f1 = "f1.txt"
  f2 = "f2.txt"
  f3 = SubDir / "file.txt"

proc newBackup(path: string): string =
  ## Create a backup file. Return the path to this file.
  if not path.fileExists():
    raise newException(IOError, "file doesn't exist.")
  let path = path.expandFilename()  # This follows symlinks.
  result = path & Suffix
  moveFile(path, result)
  result = result.relativePath(getCurrentDir())

# Prepare test files.
let oldDir = getCurrentDir()
createDir(Dir)
setCurrentDir(Dir)
createDir(SubDir)
f1.writeFile("This is version 1 of file $#" % f1)
f3.writeFile("This is version 1 of file $#" % f3)
createSymlink(f3, f2)

# Display initial state.
echo "Before backup:"
echo f1, ":                ", f1.readFile
echo f2, " → ", f3, ": ", f2.readFile()

# Create backups.
echo "\nBackup of regular file:"
let f1Backup = newBackup(f1)
f1.writeFile("This is version 2 of file $#" % f1)
echo f1, ":        ", f1.readFile()
echo f1Backup, ": ", f1Backup.readFile()

echo "\nBackup of symbolic link to file:"
let f2Backup = newBackup(f2)
f2.writeFile("This is version 2 of file $#" % f3)
echo f2, " → ", f3, ": ", f2.readFile()
echo f2Backup, ":   ", f2Backup.readFile()

# Cleanup.
setCurrentDir(oldDir)
removeDir(Dir)
