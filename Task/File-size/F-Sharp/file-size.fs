open NUnit.Framework
open FsUnit

[<Test>]
let ``Validate that the size of the two files is the same`` () =
  let local = System.IO.FileInfo(__SOURCE_DIRECTORY__ + "\input.txt")
  let root = System.IO.FileInfo(System.IO.Directory.GetDirectoryRoot(__SOURCE_DIRECTORY__) + "input.txt")
  local.Length = root.Length |> should be True
