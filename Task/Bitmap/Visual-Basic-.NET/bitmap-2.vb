Public Class RasterBitmap

    Private m_pixels() As Rgb

    Private m_width As Integer
    Public ReadOnly Property Width As Integer
        Get
            Return m_width
        End Get
    End Property

    Private m_height As Integer
    Public ReadOnly Property Height As Integer
        Get
            Return m_height
        End Get
    End Property

    Public Sub New(ByVal width As Integer, ByVal height As Integer)
        m_pixels = New Rgb(width * height - 1) {}
        m_width = width
        m_height = height
    End Sub

    Public Sub Clear(ByVal color As Rgb)
        For i As Integer = 0 To m_pixels.Length - 1
            m_pixels(i) = color
        Next
    End Sub

    Public Sub SetPixel(ByVal x As Integer, ByVal y As Integer, ByVal color As Rgb)
        m_pixels((y * m_width) + x) = color
    End Sub

    Public Function GetPixel(ByVal x As Integer, ByVal y As Integer) As Rgb
        Return m_pixels((y * m_width) + x)
    End Function

End Class
