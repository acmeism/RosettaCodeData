Option Explicit

Private Declare Function AllocConsole Lib "kernel32.dll" () As Long
Private Declare Function FreeConsole Lib "kernel32.dll" () As Long
'needs a reference set to "Microsoft Scripting Runtime" (scrrun.dll)

Sub Main()
  Call AllocConsole
  Dim mFSO As Scripting.FileSystemObject
  Dim mStdIn As Scripting.TextStream
  Dim mStdOut As Scripting.TextStream
  Set mFSO = New Scripting.FileSystemObject
  Set mStdIn = mFSO.GetStandardStream(StdIn)
  Set mStdOut = mFSO.GetStandardStream(StdOut)
  mStdOut.Write "Hello world!" & vbNewLine
  mStdOut.Write "press enter to quit program."
  mStdIn.Read 1
  Call FreeConsole
End Sub
