Dim file As New IO.FileInfo("test.txt")

'Creation Time
Dim createTime = file.CreationTime
file.CreationTime = createTime.AddHours(1)

'Write Time
Dim writeTime = file.LastWriteTime
file.LastWriteTime = writeTime.AddHours(1)

'Access Time
Dim accessTime = file.LastAccessTime
file.LastAccessTime = accessTime.AddHours(1)
