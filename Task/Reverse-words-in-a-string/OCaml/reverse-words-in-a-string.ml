#load "str.cma"
let input = ["---------- Ice and Fire ------------";
        "";
        "fire, in end will world the say Some";
        "ice. in say Some";
        "desire of tasted I've what From";
        "fire. favor who those with hold I";
        "";
        "... elided paragraph last ...";
        "";
        "Frost Robert -----------------------"];;

let splitted = List.map (Str.split (Str.regexp " ")) input in
let reversed = List.map List.rev splitted in
let final = List.map (String.concat " ") reversed in
List.iter print_endline final;;
