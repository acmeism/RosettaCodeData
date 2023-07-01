module Program
(* Learn more about F# at https://fsharp.org *)

open System

[<EntryPoint>]
let main argv =
    let sexpr =

        (* Data from file supplied at runtime or a preset string? *)
        if argv.Length > 0 then
            (* Data from file supplied at runtime *)
            begin
                (* Get the file to parse *)
                let name = argv.[0] in

                (* parse the program file *)
                SExpr.parse_file name
            end
        else
            (* Data from a preset string *)
            begin
                (* preset the string *)
                let data= "((data \"quoted data\" 123 4.5) (data (!@# (4.5) \"(more\" \"data)\")))" in

                (* parse the program file *)
                SExpr.parse_string data
            end

    (* Print the parsed program token list *)
    (printf "\nSExpr: \n");
    SExpr.print_sexpr sexpr;
    (printf "\nSExpr - Indented: \n");
    SExpr.print_sexpr_indent sexpr;

    (* return an integer exit code *)
    0
