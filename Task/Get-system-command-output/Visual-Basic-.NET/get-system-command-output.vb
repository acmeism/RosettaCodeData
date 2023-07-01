Module Module1

    Sub Main()
        Dim proccess As New Process
        Dim startInfo As New ProcessStartInfo

        startInfo.WindowStyle = ProcessWindowStyle.Hidden
        startInfo.FileName = "cmd.exe"
        startInfo.Arguments = "/c echo Hello World"
        startInfo.RedirectStandardOutput = True
        startInfo.UseShellExecute = False

        proccess.StartInfo = startInfo
        proccess.Start()

        Dim output = proccess.StandardOutput.ReadToEnd
        Console.WriteLine("Output is {0}", output)
    End Sub

End Module
