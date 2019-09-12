Imports System.Drawing
Imports System.Windows.Forms

Module Program
    ''' <summary>
    ''' Draws a Taijitu symbol on the specified <see cref="Graphics" /> surface at a specified location with a specified size.
    ''' </summary>
    ''' <param name="g">The <see cref="Graphics" /> surface to draw on.</param>
    ''' <param name="location">The coordinates of the upper-left corner of the bounding rectangle that defines the symbol.</param>
    ''' <param name="diameter">The diameter of the symbol, or the width and height of its bounding rectangle.</param>
    ''' <param name="drawOutline">Whether to draw an outline around the symbol.</param>
    Sub DrawTaijitu(g As Graphics, location As PointF, diameter As Single, drawOutline As Boolean)
        Const sixth = 1 / 6

        g.ResetTransform()
        g.TranslateTransform(location.X, location.Y)
        g.ScaleTransform(diameter, diameter)

        g.FillPie(Brushes.Black, x:=0, y:=0, width:=1, height:=1, startAngle:=90, sweepAngle:=180)  ' Left half.
        g.FillPie(Brushes.White, x:=0, y:=0, width:=1, height:=1, startAngle:=270, sweepAngle:=180) ' Right half.
        g.FillEllipse(Brushes.Black, x:=0.25, y:=0, width:=0.5, height:=0.5)                        ' Upper ball.
        g.FillEllipse(Brushes.White, x:=0.25, y:=0.5, width:=0.5, height:=0.5)                      ' Lower ball.
        g.FillEllipse(Brushes.White, x:=0.5 - sixth / 2, y:=sixth, width:=sixth, height:=sixth)     ' Upper dot.
        g.FillEllipse(Brushes.Black, x:=0.5 - sixth / 2, y:=4 * sixth, width:=sixth, height:=sixth) ' Lower dot.

        If drawOutline Then
            Using p As New Pen(Color.Black, width:=2 / diameter)
                g.DrawEllipse(p, x:=0, y:=0, width:=1, height:=1)
            End Using
        End If
    End Sub

    ''' <summary>
    ''' Draws one large and one small Taijitu symbol on the specified <see cref="Graphics" /> surface.
    ''' </summary>
    ''' <param name="g">The <see cref="Graphics" /> surface to draw on.</param>
    ''' <param name="bounds">The width and height of the area to draw in.</param>
    Sub DrawDemo(g As Graphics, bounds As Single)
        Const PADDING = 10
        Dim ACTUAL = bounds - (PADDING * 2)

        g.SmoothingMode = Drawing2D.SmoothingMode.AntiAlias

        DrawTaijitu(g, location:=New PointF(PADDING, PADDING), diameter:=ACTUAL / 4, drawOutline:=True)
        DrawTaijitu(g, location:=New PointF(PADDING + (bounds / 5), PADDING + (ACTUAL / 5)), diameter:=ACTUAL * 4 / 5, drawOutline:=True)
    End Sub

    Sub Main(args As String())
        If args.Length = 0 Then
            Using frm As New YinYangForm()
                frm.ShowDialog()
            End Using

        Else
            Dim imageSize = Integer.Parse(args(0), Globalization.CultureInfo.InvariantCulture)

            Using bmp As New Bitmap(imageSize, imageSize),
                  g = Graphics.FromImage(bmp),
                  output = Console.OpenStandardOutput()

                Try
                    DrawDemo(g, imageSize)
                    bmp.Save(output, Imaging.ImageFormat.Png)
                Catch ex As Exception
                    MessageBox.Show("Specified size is too small", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End Using
        End If
    End Sub

    Private Class YinYangForm
        Inherits Form

        Sub Form_Paint() Handles Me.Paint
            Dim availableSize = Math.Min(Me.DisplayRectangle.Width, Me.DisplayRectangle.Height)
            Dim g As Graphics
            Try
                g = Me.CreateGraphics()
                DrawDemo(g, availableSize)
            Catch ex As Exception
                MessageBox.Show("Window size too small.", "Exception thrown", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Finally
                If g IsNot Nothing Then g.Dispose()
            End Try
        End Sub
    End Class
End Module
