' program_freebasic_fake_compiler.bas
Dim As String progCode
Dim As String tempFile

progCode = "print ""Hello, World!""" & Chr(10) ' Interpreted code as a string
tempFile = "temp_interpret_i.txt"

' Create the temporary file with the code to be interpreted
Dim As Integer fileNum = FreeFile()
Open tempFile For Output As #fileNum
Print #fileNum, progCode
Close #fileNum

' Run the external interpreter with the temporary file
Shell("InterpretI " + tempFile)

' Delete the temporary file
