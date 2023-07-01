- val strings = Array.fromList ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"];
val strings = [|"Here","are","some","sample","strings","to","be","sorted"|]
  : string array
- ArrayQSort.sort mycmp strings;
val it = () : unit
- strings;
val it = [|"strings","sample","sorted","Here","some","are","be","to"|]
  : string array
