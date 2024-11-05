Imports System

Module Program
  Sub Main(args As String())
    Brainfug("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.")
  End Sub

  Sub Brainfug(code As String, Optional input As String = Nothing)
    Dim inp As Integer = 1 ' input pointer if we use an input string
    Dim tape(29999) As Integer ' yes, 29999 makes an array of 30000
    Dim p As Integer
    For i = 1 To code.Length
      Dim c As Char = Mid(code, i, 1)
      Select c
        Case ">"
          p += 1
        Case "<"
          p -= 1
        Case "+"
          tape(p) += 1
        Case "-"
          tape(p) -= 1
        Case "."
          Try
            Console.Write(Chr(tape(p)))
          Catch ex As NotSupportedException
            Console.Write(".")
          End Try
        Case ","
          If input Is Nothing then
            tape(p) = Console.Read()
          Else
            Try
              tape(p) = AscW(Mid(input, inp, 1))
            Catch ex As ArgumentException
              Console.WriteLine("Panic: Out of input!")
              Environment.Exit(1)
            End Try
            inp += 1
          End If
        Case "["
          If tape(p) = 0
            Dim nest = 1
            While nest
              i += 1
              Select Mid(code, i, 1)
                Case "]"
                  nest -= 1
                Case "["
                  nest += 1
              End Select
            End While
          End If
        Case "]"
          If tape(p) <> 0
            Dim nest = 1
            While nest
              i -= 1
              Select Mid(code, i, 1)
                Case "["
                  nest -= 1
                Case "]"
                  nest += 1
              End Select
            End While
          End If
      End Select
    Next
  End Sub
End Module
