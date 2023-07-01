Using input = IO.File.OpenText("input.txt"), _
      output As New IO.StreamWriter(IO.File.OpenWrite("output.txt"))
  output.Write(input.ReadToEnd)
End Using
