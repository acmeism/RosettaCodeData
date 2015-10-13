set pathToTextFile to ((path to desktop folder as string) & "testfile.txt")

-- short way: open, read and close in one step
set fileContent to read file pathToTextFile

-- long way: open a file reference, read content and close access
set fileRef to open for access pathToTextFile
set fileContent to read fileRef
close access fileRef
