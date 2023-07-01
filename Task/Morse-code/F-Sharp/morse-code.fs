open System
open System.Threading

let morse = Map.ofList
                [('a', "._ "); ('b', "_... "); ('c', "_._. "); ('d', "_.. ");
                ('e', ". "); ('f', ".._. "); ('g', "__. "); ('h', ".... ");
                ('i', ".. "); ('j', ".___ "); ('k', "_._ "); ('l', "._.. ");
                ('m', "__ "); ('n', "_. "); ('o', "___ "); ('p', ".__. ");
                ('q', "__._ "); ('r', "._. "); ('s', "... "); ('t', "_ ");
                ('u', ".._ "); ('v', "..._ "); ('w', ".__ "); ('x', "_.._ ");
                ('y', "_.__ "); ('z', "__.. "); ('0', "_____ "); ('1', ".____ ");
                ('2', "..___ "); ('3', "...__ "); ('4', "...._ "); ('5', "..... ");
                ('6', "_.... "); ('7', "__... "); ('8', "___.. "); ('9', "____. ")]

let beep c =
    match c with
    | '.' ->
        printf "."
        Console.Beep(1200, 250)
    | '_' ->
        printf "_"
        Console.Beep(1200, 1000)
    | _ ->
        printf " "
        Thread.Sleep(125)

let trim (s: string) = s.Trim()
let toMorse c = Map.find c morse
let lower (s: string) = s.ToLower()
let sanitize = String.filter Char.IsLetterOrDigit

let send = sanitize >> lower >> String.collect toMorse >> trim >> String.iter beep

send "Rosetta Code"
