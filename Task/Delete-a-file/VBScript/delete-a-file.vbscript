Set oFSO = CreateObject( "Scripting.FileSystemObject" )

oFSO.DeleteFile "input.txt"
oFSO.DeleteFolder "docs"

oFSO.DeleteFile "\input.txt"
oFSO.DeleteFolder "\docs"

'Using Delete on file and folder objects

dim fil, fld

set fil = oFSO.GetFile( "input.txt" )
fil.Delete
set fld = oFSO.GetFolder( "docs" )
fld.Delete

set fil = oFSO.GetFile( "\input.txt" )
fil.Delete
set fld = oFSO.GetFolder( "\docs" )
fld.Delete
