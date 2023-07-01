let myCompare (s1:string) (s2:string) =
  match compare s2.Length s1.Length with
    | 0 -> compare (s1.ToLower()) (s2.ToLower())
    | X -> X

let strings = ["Here"; "are"; "some"; "sample"; "strings"; "to"; "be"; "sorted"]

let sortedStrings = List.sortWith myCompare strings

printfn "%A" sortedStrings
