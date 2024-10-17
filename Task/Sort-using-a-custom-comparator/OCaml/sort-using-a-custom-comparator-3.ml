# let strings = [|"Here"; "are"; "some"; "sample"; "strings"; "to"; "be"; "sorted"|];;
val strings : string array =
  [|"Here"; "are"; "some"; "sample"; "strings"; "to"; "be"; "sorted"|]
# Array.sort mycmp strings;;
- : unit = ()
# strings;;
- : string array =
[|"strings"; "sample"; "sorted"; "Here"; "some"; "are"; "be"; "to"|]
