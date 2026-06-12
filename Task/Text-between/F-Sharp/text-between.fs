let GetTextBetween (text: string) (start_delim: string) (end_delim: string) : string =
    let start_index =
        if start_delim = "start" then
            0 // Special case: start from the beginning
        else
            match text.IndexOf start_delim with
            | -1 -> -1 // Start delimiter not found
            | i -> i + start_delim.Length

    if start_index = -1 then
        "" // Return empty string if start delimiter not found
    else
        let end_index =
            if end_delim = "end" then
                text.Length // Special case: set to the end of the string
            else
                text.IndexOf(end_delim, start_index)

        if end_index = -1 then
            text[start_index..]
        else
            text[start_index .. end_index - 1] // Extract substring between delimiters

// A test case record
type Test =
    { Text: string
      Start_delimiter: string
      End_delimiter: string
      Expect: string }

let tests =
    [ { Start_delimiter = "Hello "
        End_delimiter = " world"
        Expect = "Rosetta Code"
        Text = "Hello Rosetta Code world" }
      { Start_delimiter = "start"
        End_delimiter = " world"
        Expect = "Hello Rosetta Code"
        Text = "Hello Rosetta Code world" }
      { Start_delimiter = "Hello "
        End_delimiter = "end"
        Expect = "Rosetta Code world"
        Text = "Hello Rosetta Code world" }
      { Start_delimiter = "<div style=\"chinese\">"
        End_delimiter = "</div>"
        Expect = "你好嗎"
        Text = "</div><div style=\"chinese\">你好嗎</div>" }
      { Start_delimiter = "<text>"
        End_delimiter = "<table>"
        Expect = "Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">"
        Text = "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">" }
      { Start_delimiter = "<table>"
        End_delimiter = "</table>"
        Expect = ""
        Text = "<table style=\"myTable\"><tr><td>hello world</td></tr></table>" }
      { Start_delimiter = "quick "
        End_delimiter = " fox"
        Expect = "brown"
        Text = "The quick brown fox jumps over the lazy other fox" }
      { Start_delimiter = "fish "
        End_delimiter = " red"
        Expect = "two fish"
        Text = "One fish two fish red fish blue fish" }
      { Start_delimiter = "Foo"
        End_delimiter = "Foo"
        Expect = "BarBaz"
        Text = "FooBarBazFooBuxQuux" } ]

// Run all test cases and check results
for i,
    { Start_delimiter = start
      End_delimiter = end_d
      Expect = exp
      Text = text } in tests |> Seq.indexed do
    let res = GetTextBetween text start end_d

    if res <> exp then
        failwith $"{i}: Expected '{exp}' but got '{res}'"
    else printfn "%i: %s" i res

printfn "\n----\nPassed"
