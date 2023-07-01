Option Explicit
Declare Sub GetMem1 Lib "msvbvm60" (ByVal ptr As Long, ByRef x As Byte)
Declare Sub GetMem2 Lib "msvbvm60" (ByVal ptr As Long, ByRef x As Integer)
Declare Sub GetMem4 Lib "msvbvm60" (ByVal ptr As Long, ByRef x As Long)
Declare Sub PutMem1 Lib "msvbvm60" (ByVal ptr As Long, ByVal x As Byte)
Declare Sub PutMem2 Lib "msvbvm60" (ByVal ptr As Long, ByVal x As Integer)
Declare Sub PutMem4 Lib "msvbvm60" (ByVal ptr As Long, ByVal x As Long)

Sub Test()
    Dim a As Long, ptr As Long, s As Long
    a = 12345678

    'Get and print address
    ptr = VarPtr(a)
    Debug.Print ptr

    'Peek
    Call GetMem4(ptr, s)
    Debug.Print s

    'Poke
    Call PutMem4(ptr, 87654321)
    Debug.Print a
End Sub
