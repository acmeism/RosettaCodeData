let d = [|
  "I know an old lady who swallowed a "; "fly"; ".\n";
  "I don't know why she swallowed the fly.\nPerhaps she'll die.\n\n";
  "spider"; "That wriggled and jiggled and tickled inside her";
  "She swallowed the "; " to catch the "; "Bird"; "Quite absurd";
  ". To swallow a "; "Cat"; "Fancy that"; "Dog"; "What a hog"; "Pig";
  "Her mouth was so big"; "Goat"; "She just opened her throat"; "Cow";
  "I don't know how"; "Donkey"; "It was rather wonky";
  "I know an old lady who swallowed a Horse.\nShe's dead, of course!\n";
|]

let s0 = [6;4;7;1;2;3]
let s1 = [6;8;7;4;2]   @ s0
let s2 = [6;11;7;8;2]  @ s1
let s3 = [6;13;7;11;2] @ s2
let s4 = [6;15;7;13;2] @ s3
let s5 = [6;17;7;15;2] @ s4
let s6 = [6;19;7;17;2] @ s5
let s7 = [6;21;7;19;2] @ s6

let s =
  [0;1;2;3;0;4;2;5;2] @ s0 @
  [0;8;2;9;10;8;2]    @ s1 @
  [0;11;2;12;10;11;2] @ s2 @
  [0;13;2;14;10;13;2] @ s3 @
  [0;15;2;16;10;15;2] @ s4 @
  [0;17;2;18;10;17;2] @ s5 @
  [0;19;2;20;10;19;2] @ s6 @
  [0;21;2;22;10;21;2] @ s7 @
  [23] ;;

List.iter (fun i -> print_string d.(i)) s
