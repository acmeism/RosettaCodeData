# let strings = ["Here"; "are"; "some"; "sample"; "strings"; "to"; "be"; "sorted"];;
val strings : string list =
  ["Here"; "are"; "some"; "sample"; "strings"; "to"; "be"; "sorted"]
# List.sort mycmp strings;;
- : string list =
["strings"; "sample"; "sorted"; "Here"; "some"; "are"; "be"; "to"]
