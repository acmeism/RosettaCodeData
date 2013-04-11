Public Class ForestFire
    Private _forest(,) As ForestState
    Private _isBuilding As Boolean
    Private _bm As Bitmap
    Private _gen As Integer
    Private _sw As Stopwatch

    Private Const _treeStart As Double = 0.5
    Private Const _f As Double = 0.00001
    Private Const _p As Double = 0.001

    Private Const _winWidth As Integer = 300
    Private Const _winHeight As Integer = 300

    Private Enum ForestState
        Empty
        Burning
        Tree
    End Enum

    Private Sub ForestFire_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Me.ClientSize = New Size(_winWidth, _winHeight)
        ReDim _forest(_winWidth, _winHeight)

        Dim rnd As New Random()
        For i As Integer = 0 To _winHeight - 1
            For j As Integer = 0 To _winWidth - 1
                _forest(j, i) = IIf(rnd.NextDouble <= _treeStart, ForestState.Tree, ForestState.Empty)
            Next
        Next

        _sw = New Stopwatch
        _sw.Start()
        DrawForest()
        Timer1.Start()
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        If _isBuilding Then Exit Sub

        _isBuilding = True
        GetNextGeneration()

        DrawForest()
        _isBuilding = False
    End Sub

    Private Sub GetNextGeneration()
        Dim forestCache(_winWidth, _winHeight) As ForestState
        Dim rnd As New Random()

        For i As Integer = 0 To _winHeight - 1
            For j As Integer = 0 To _winWidth - 1
                Select Case _forest(j, i)
                    Case ForestState.Tree
                        If forestCache(j, i) <> ForestState.Burning Then
                            forestCache(j, i) = IIf(rnd.NextDouble <= _f, ForestState.Burning, ForestState.Tree)
                        End If

                    Case ForestState.Burning
                        For i2 As Integer = i - 1 To i + 1
                            If i2 = -1 OrElse i2 >= _winHeight Then Continue For
                            For j2 As Integer = j - 1 To j + 1
                                If j2 = -1 OrElse i2 >= _winWidth Then Continue For
                                If _forest(j2, i2) = ForestState.Tree Then forestCache(j2, i2) = ForestState.Burning
                            Next
                        Next
                        forestCache(j, i) = ForestState.Empty

                    Case Else
                        forestCache(j, i) = IIf(rnd.NextDouble <= _p, ForestState.Tree, ForestState.Empty)
                End Select
            Next
        Next

        _forest = forestCache
        _gen += 1
    End Sub

    Private Sub DrawForest()
        Dim bmCache As New Bitmap(_winWidth, _winHeight)

        For i As Integer = 0 To _winHeight - 1
            For j As Integer = 0 To _winWidth - 1
                Select Case _forest(j, i)
                    Case ForestState.Tree
                        bmCache.SetPixel(j, i, Color.Green)

                    Case ForestState.Burning
                        bmCache.SetPixel(j, i, Color.Red)
                End Select
            Next
        Next

        _bm = bmCache
        Me.Refresh()
    End Sub

    Private Sub ForestFire_Paint(ByVal sender As System.Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles MyBase.Paint
        e.Graphics.DrawImage(_bm, 0, 0)

        Me.Text = "Gen " & _gen.ToString() & " @ " & (_gen / (_sw.ElapsedMilliseconds / 1000)).ToString("F02") & " FPS: Forest Fire"
    End Sub
End Class
