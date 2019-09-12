Imports System.Diagnostics
' Note: VB Visual Studio projects have System.Diagnostics imported by default,
' along with several other namespaces.

Module Program
    Sub Main()
        Dim a As Integer = 0

        Console.WriteLine("Before")

        ' Always hit.
        Trace.Assert(a = 42, "Trace assertion failed: The Answer was incorrect")

        Console.WriteLine("After Trace.Assert")

        ' Only hit in debug builds.
        Debug.Assert(a = 42, "Debug assertion failed: The Answer was incorrect")

        Console.WriteLine("After Debug.Assert")
    End Sub
End Module
