Using input = IO.File.OpenText("input.txt"), _
      output As New IO.StreamWriter(IO.File.OpenWrite("output.txt"))
  Do Until input.EndOfStream
    output.WriteLine(input.ReadLine)
  Loop
End Using
