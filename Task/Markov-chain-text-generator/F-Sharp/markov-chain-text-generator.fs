let ngram len source i = source |> List.skip i |> List.take len
let trailing len source = ngram len source (Seq.length source - len)
let leading = List.take

let buildMap prefixLen source =
    let add map sequence =
        let prefix = leading (Seq.length sequence - 1) sequence
        let suffix = Seq.last sequence
        let existingSuffixes = map |> Map.tryFind prefix |> Option.defaultValue []
        // add a suffix to existing suffixes, probably creating duplicated entries
        Map.add prefix (suffix :: existingSuffixes) map
    let ngramCount = Seq.length source - prefixLen
    Seq.init ngramCount (ngram (prefixLen + 1) source) |> Seq.fold add (Map[])

let generate outputLenLimit seed map =
    let random = System.Random()
    let pickSuffix prefix =
        let randomItem suffixes = List.item (List.length suffixes |> random.Next) suffixes
        // as the list of suffixes contains duplicates, probability of any distinct word
        // is proportional to its frequency in the source text
        map |> Map.tryFind prefix |> Option.map randomItem
    let prefixLen = Seq.length seed
    let add list word = list @ [word]
    let append output _ =
        trailing prefixLen output |> pickSuffix |> Option.map (add output) |> Option.defaultValue output
    Seq.init outputLenLimit id |> Seq.fold append seed

let markov prefixLen outputLenLimit source =
    let map = buildMap prefixLen source
    let seed = leading prefixLen source
    generate outputLenLimit seed map |> String.concat " "

"alice_oz.txt"
    |> System.IO.File.ReadAllText
    |> (fun t -> t.Split ' ')
    |> List.ofSeq
    |> markov 2 100
