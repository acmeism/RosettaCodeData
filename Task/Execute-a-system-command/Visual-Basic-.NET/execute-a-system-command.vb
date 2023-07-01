Module System_Command

    Sub Main()
        Dim cmd As New Process
        cmd.StartInfo.FileName = "cmd.exe"
        cmd.StartInfo.RedirectStandardInput = True
        cmd.StartInfo.RedirectStandardOutput = True
        cmd.StartInfo.CreateNoWindow = True
        cmd.StartInfo.UseShellExecute = False

        cmd.Start()

        cmd.StandardInput.WriteLine("dir")
        cmd.StandardInput.Flush()
        cmd.StandardInput.Close()

        Console.WriteLine(cmd.StandardOutput.ReadToEnd)
    End Sub

End Module
