Imports System.Drawing
Imports System.Windows.Forms

Module Program
    Sub Main()
        Using f As New Form() With {
            .WindowState = FormWindowState.Maximized,
            .FormBorderStyle = FormBorderStyle.None
            }

            f.Show()
            Console.WriteLine($"Size of maximized borderless form:  {f.Width}x{f.Height}")
        End Using
    End Sub
End Module
