Imports System.Numerics

Module Module1
  Function IsOdd(bi As BigInteger) As Boolean
    Return Not bi.IsEven
  End Function

  Function IsEven(bi As BigInteger) As Boolean
    Return bi.IsEven
  End Function

  Sub Main()
    ' uncomment one of the following Dim statements
    ' Dim x As Byte = 3
    ' Dim x As Short = 3
    ' Dim x As Integer = 3
    ' Dim x As Long = 3
    ' Dim x As SByte = 3
    ' Dim x As UShort = 3
    ' Dim x As UInteger = 3
    ' Dim x As ULong = 3
    ' Dim x as BigInteger = 3
    ' the following three types give a warning, but will work
    ' Dim x As Single = 3
    ' Dim x As Double = 3
    ' Dim x As Decimal = 3

    Console.WriteLine("{0} {1}", IsOdd(x), IsEven(x))
  End Sub
End Module
