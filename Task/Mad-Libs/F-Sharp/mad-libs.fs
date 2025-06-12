open System
open System.Collections.Generic
open System.Text

type Template(s: string, d: Dictionary<string, string>) =
    let text = s
    let substitutes = d

    new(s: string) =
        let d = Dictionary()

        let rec collect (idx: int) =
            let start_idx = s.IndexOf('<', idx)

            if start_idx = -1 then
                ()
            else
                let end_idx = s.IndexOf('>', start_idx)

                if end_idx = -1 then
                    failwith "Malformed input"

                d.TryAdd(s[start_idx..end_idx], "") |> ignore
                collect (end_idx + 1)

        collect 0
        Template(s, d)

    override _.ToString() =
        let mutable s = text

        for KeyValue (name, value) in substitutes do
            if value = "" then
                s <- s.Replace(name, name + ": <NIL>")
            else
                s <- s.Replace(name, value)

        s

    member _.AskForSubstitutes() =
        for KeyValue (name, _) in substitutes do
            printf $"Enter a {name}: "
            let input = Console.ReadLine()
            substitutes[name] <- input.Trim()

let story =
    let rec read (acc: StringBuilder) =
        let line = Console.ReadLine()

        if line.Trim() = "" then
            acc
        else
            acc.Append(line + "\n") |> ignore
            read acc

    let mutable acc = StringBuilder()
    printfn "Enter a multi-line story (finish with blank line):"
    (read acc).ToString().Trim()

let story_template = Template story
story_template.AskForSubstitutes()
printfn "\n"
printfn $"{story_template}"
