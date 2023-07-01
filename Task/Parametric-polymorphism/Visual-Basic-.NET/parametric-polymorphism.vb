Class BinaryTree(Of T)
    ReadOnly Property Left As BinaryTree(Of T)
    ReadOnly Property Right As BinaryTree(Of T)
    ReadOnly Property Value As T

    Sub New(value As T, Optional left As BinaryTree(Of T) = Nothing, Optional right As BinaryTree(Of T) = Nothing)
        Me.Value = value
        Me.Left = left
        Me.Right = right
    End Sub

    Function Map(Of U)(f As Func(Of T, U)) As BinaryTree(Of U)
        Return New BinaryTree(Of U)(f(Me.Value), Me.Left?.Map(f), Me.Right?.Map(f))
    End Function

    Overrides Function ToString() As String
        Dim sb As New Text.StringBuilder()
        Me.ToString(sb, 0)
        Return sb.ToString()
    End Function

    Private Overloads Sub ToString(sb As Text.StringBuilder, depth As Integer)
        sb.Append(New String(ChrW(AscW(vbTab)), depth))
        sb.AppendLine(Me.Value?.ToString())
        Me.Left?.ToString(sb, depth + 1)
        Me.Right?.ToString(sb, depth + 1)
    End Sub
End Class

Module Program
    Sub Main()
        Dim b As New BinaryTree(Of Integer)(6, New BinaryTree(Of Integer)(5), New BinaryTree(Of Integer)(7))
        Dim b2 As BinaryTree(Of Double) = b.Map(Function(x) x * 0.5)

        Console.WriteLine(b)
        Console.WriteLine(b2)
    End Sub
End Module
