Attribute VB_Name = "mdlShellAndWait"
Option Explicit

Private Declare Function OpenProcess Lib "kernel32" _
    (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, _
    ByVal dwProcessId As Long) As Long

Private Declare Function GetExitCodeProcess Lib "kernel32" _
    (ByVal hProcess As Long, lpExitCode As Long) As Long

Private Const STATUS_PENDING = &H103&
Private Const PROCESS_QUERY_INFORMATION = &H400

'
' Little function go get exit code given processId
'
Function ProcessIsRunning( processId as Long ) as Boolean
    Dim exitCode as Long
    Call GetExitCodeProcess(lProcessId, exitCode)
    ProcessIsRunning = (exitCode = STATUS_PENDING)
End Function

' Spawn subprocess and wait for it to complete.
'   I believe that the command in the command line must be an exe or a bat file.
'   Maybe, however, it can reference any file the system knows how to "Open"
'
' commandLine is an executable.
' expectedDuration - is for poping up a dialog for whatever
' infoText - text for progressDialog dialog

Public Function ShellAndWait( commandLine As String, _
    expectedDuration As Integer ) As Boolean

    Dim inst As Long
    Dim startTime As Long
    Dim expirationTime As Long
    Dim pid As Long
    Dim expiresSameDay As Boolean

    On Error GoTo HandleError

    'Deal with timeout being reset at Midnight ($hitForBrains VB folks)
    startTime = CLng(Timer)
    expirationTime = startTime + expectedDuration
    expiresSameDay = expirationTime < 86400
    If Not expiresSameDay Then
        expirationTime = expirationTime - 86400
    End If

    inst = Shell(commandLine, vbMinimizedNoFocus)

    If inst <> 0 Then
        pid = OpenProcess(PROCESS_QUERY_INFORMATION, False, inst)

        Do While ProcessIsRunning( pid)
            DoEvents
            If Timer > expirationTime And (expiresSameDay Or Timer < startTime) Then
                Exit Do
            End If
        Loop
        ShellAndWait = True
    Else
        MsgBox ("Couldn't execute command: " & commandLine)
        ShellAndWait = False
    End If

    Exit Function

HandleError:
    MsgBox ("Couldn't execute command: " & commandLine)
    ShellAndWait = False
End Function

Sub SpawnDir()
   ShellAndWait("dir", 10)
End Sub
