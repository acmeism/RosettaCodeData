' The StructLayout attribute allows fields to overlap in memory.
<System.Runtime.InteropServices.StructLayout(LayoutKind.Explicit)> _
Public Structure Rgb

    <FieldOffset(0)> _
    Public Rgb As Integer

    <FieldOffset(0)> _
    Public B As Byte

    <FieldOffset(1)> _
    Public G As Byte

    <FieldOffset(2)> _
    Public R As Byte

    Public Sub New(ByVal r As Byte, ByVal g As Byte, ByVal b As Byte)
        Me.R = r
        Me.G = g
        Me.B = b
    End Sub

End Structure
