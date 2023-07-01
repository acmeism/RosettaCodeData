Imports System.Drawing.Imaging

Public Class frmSnowExercise
    Dim bRunning As Boolean = True

    Private Sub Form1_Load(ByVal sender As System.Object,
                           ByVal e As System.EventArgs) Handles MyBase.Load

        ' Tell windows we want to handle all the painting and that we want it
        '  to double buffer the form's rectangle (Double Buffering
        '  removes/ reduces flickering).
        SetStyle(ControlStyles.AllPaintingInWmPaint Or ControlStyles.UserPaint _
            Or ControlStyles.OptimizedDoubleBuffer, True)
        UpdateStyles()

        ' Prevent the user from resizing the window. Our draw code is not
        ' setup to recalculate on the fly.
        FormBorderStyle = Windows.Forms.FormBorderStyle.FixedSingle
        MaximizeBox = False

        ' The window size and the client rectangle aren't the same.
        ' To get the proper dimensions for our exercise we need to
        ' figure out the difference and add it to our 320x240
        ' requirement.
        Width = 320 + Size.Width - ClientSize.Width
        Height = 240 + Size.Height - ClientSize.Height

        ' Pop the window, bring it to the front and give windows time to
        ' reflect the changes.
        Show()
        Activate()
        Application.DoEvents()

        ' Hit the loop and keep going until we receive a close request.
        RenderLoop()

        ' We're done. Exit the application.
        Close()

    End Sub

    Private Sub Form1_KeyPress(ByVal sender As Object, ByVal e As _
            System.Windows.Forms.KeyPressEventArgs) Handles Me.KeyPress
        ' Close the application when the user hits escape.
        If e.KeyChar = ChrW(Keys.Escape) Then bRunning = False
    End Sub

    Private Sub Form1_FormClosing(ByVal sender As Object, ByVal e As _
            System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        ' We'll cancel the form close request if we're still running so we
        ' don't get an error during runtime and set the close request flag.
        e.Cancel = bRunning
        bRunning = False
    End Sub

    Private Sub RenderLoop()

        Const cfPadding As Single = 5.0F

        Dim b As New Bitmap(ClientSize.Width, ClientSize.Width,
                            PixelFormat.Format32bppArgb)
        Dim g As Graphics = Graphics.FromImage(b)
        Dim r As New Random(Now.Millisecond)
        Dim oBMPData As BitmapData = Nothing
        Dim oPixels() As Integer = Nothing
        Dim oBlackWhite() As Integer = {Color.White.ToArgb, Color.Black.ToArgb}
        Dim oStopwatch As New Stopwatch
        Dim fElapsed As Single = 0.0F
        Dim iLoops As Integer = 0
        Dim sFPS As String = "0.0 FPS"
        Dim oFPSSize As SizeF = g.MeasureString(sFPS, Font)
        Dim oFPSBG As RectangleF = New RectangleF(ClientSize.Width - cfPadding -
                      oFPSSize.Width, cfPadding, oFPSSize.Width, oFPSSize.Height)

        ' Get ourselves a nice, clean, black canvas to work with.
        g.Clear(Color.Black)

        ' Prep our bitmap for a read.
        oBMPData = b.LockBits(New Rectangle(0, 0, b.Width, b.Height),
                          ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb)

        ' Allocate sufficient space for the pixel data and
        ' flash copy it to our array.
        ' We want an integer to hold the color for each pixel in the canvas.
        Array.Resize(oPixels, b.Width * b.Height)
        Runtime.InteropServices.Marshal.Copy(oBMPData.Scan0,
                                             oPixels, 0, oPixels.Length)
        b.UnlockBits(oBMPData)
        ' Start looping.
        Do
            ' Find our frame time and add it to the total amount of time
            ' elapsed since our last FPS update (once per second).
            fElapsed += oStopwatch.ElapsedMilliseconds / 1000.0F
            oStopwatch.Reset() : oStopwatch.Start()
            ' Adjust the number of loops since the last whole second has elapsed
            iLoops += 1
            If fElapsed >= 1.0F Then
                ' Since we've now had a whole second elapse
                ' figure the Frames Per Second,
                ' measure our string,
                ' setup our backing rectangle for the FPS string
                '        (so it's clearly visible over the snow)
                ' reset our loop counter
                ' and our elapsed counter.
                sFPS = (iLoops / fElapsed).ToString("0.0") & " FPS"
                oFPSSize = g.MeasureString(sFPS, Font)
                oFPSBG = New RectangleF(ClientSize.Width - cfPadding -
                    oFPSSize.Width, cfPadding, oFPSSize.Width, oFPSSize.Height)
                ' We don't set this to 0 in case our frame time has gone
                '  a bit over 1 second since last update.
                fElapsed -= 1.0F
                iLoops = 0
            End If

            ' Generate our snow.
            For i As Integer = 0 To oPixels.GetUpperBound(0)
                oPixels(i) = oBlackWhite(r.Next(oBlackWhite.Length))
            Next

            ' Prep the bitmap for an update.
            oBMPData = b.LockBits(New Rectangle(0, 0, b.Width, b.Height),
                       ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb)
            ' Flash copy the new data into our bitmap.
            Runtime.InteropServices.Marshal.Copy(oPixels, 0, oBMPData.Scan0,
                                                 oPixels.Length)
            b.UnlockBits(oBMPData)

            ' Draw the backing for our FPS display.
            g.FillRectangle(Brushes.Black, oFPSBG)
            ' Draw our FPS.
            g.DrawString(sFPS, Font, Brushes.Yellow, oFPSBG.Left, oFPSBG.Top)

            ' Update the form's background and draw.
            BackgroundImage = b
            Invalidate(ClientRectangle)

            ' Let windows handle some queued events.
            Application.DoEvents()
        Loop While bRunning

    End Sub
End Class
