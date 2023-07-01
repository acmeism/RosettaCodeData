open System
open System.IO
open System.Text.RegularExpressions

type Rule = {
    matches : Regex
    replacement : string
    terminate : bool
}

let (|RegexMatch|_|) regexStr input =
    let m = Regex.Match(input, regexStr, RegexOptions.ExplicitCapture)
    if m.Success then Some (m) else None

let (|RuleReplace|_|) rule input =
    let replaced = rule.matches.Replace(input, rule.replacement, 1, 0)
    if input = replaced then None
    else Some (replaced, rule.terminate)

let parseRules line =
    match line with
    | RegexMatch "^#" _ -> None
    | RegexMatch "(?<pattern>.*?)\s+->\s+(?<replacement>.*)$" m ->
        let replacement = (m.Groups.Item "replacement").Value
        let terminate = replacement.Length > 0 && replacement.Substring(0,1) = "."
        let pattern = (m.Groups.Item "pattern").Value
        Some {
            matches = pattern |> Regex.Escape |> Regex;
            replacement = if terminate then replacement.Substring(1) else replacement;
            terminate = terminate
        }
    | _ -> failwith "illegal rule definition"

let rec applyRules input = function
| [] -> (input, true)
| rule::rules ->
    match input with
    | RuleReplace rule (withReplacement, terminate) ->
        (withReplacement, terminate)
    | _ -> applyRules input rules

[<EntryPoint>]
let main argv =
    let rules = File.ReadAllLines argv.[0] |> Array.toList |> List.choose parseRules
    let rec run input =
        let output, terminate = applyRules input rules
        if terminate then output
        else run output

    Console.ReadLine()
    |> run
    |> printfn "%s"
    0
