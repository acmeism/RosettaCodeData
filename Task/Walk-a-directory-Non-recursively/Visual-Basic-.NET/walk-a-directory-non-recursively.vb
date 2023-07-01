'Using the OS pattern matching
For Each file In IO.Directory.GetFiles("\temp", "*.txt")
  Console.WriteLine(file)
Next

'Using VB's pattern matching and LINQ
For Each file In (From name In IO.Directory.GetFiles("\temp") Where name Like "*.txt")
  Console.WriteLine(file)
Next

'Using VB's pattern matching and dot-notation
For Each file In IO.Directory.GetFiles("\temp").Where(Function(f) f Like "*.txt")
  Console.WriteLine(file)
Next
