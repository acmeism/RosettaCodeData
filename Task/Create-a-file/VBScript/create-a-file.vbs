Set objFSO = CreateObject("Scripting.FileSystemObject")

'current directory
objFSO.CreateFolder(".\docs")
objFSO.CreateTextFile(".\docs\output.txt")

'root directory
objFSO.CreateFolder("\docs")
objFSO.CreateTextFile("\docs\output.txt")
