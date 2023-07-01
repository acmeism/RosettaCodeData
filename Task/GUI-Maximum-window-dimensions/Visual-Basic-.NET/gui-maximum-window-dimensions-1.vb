Imports System.Drawing
Imports System.Windows.Forms

Module Program
    Sub Main()
        Dim bounds As Rectangle = Screen.PrimaryScreen.Bounds
        Console.WriteLine($"Primary screen bounds:  {bounds.Width}x{bounds.Height}")

        Dim workingArea As Rectangle = Screen.PrimaryScreen.WorkingArea
        Console.WriteLine($"Primary screen working area:  {workingArea.Width}x{workingArea.Height}")
    End Sub
End Module
