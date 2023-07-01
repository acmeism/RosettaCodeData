let lines_of_file file =
  seq { use stream = System.IO.File.OpenRead file
        use reader = new System.IO.StreamReader(stream)
        while not reader.EndOfStream do
          yield reader.ReadLine() }
