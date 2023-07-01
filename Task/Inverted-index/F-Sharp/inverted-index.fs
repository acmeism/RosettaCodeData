open System
open System.IO

// Map search terms to associated set of files
type searchIndexMap = Map<string, Set<string>>

let inputSearchCriteria() =
    let readLine prompt =
        printf "%s: " prompt
        Console.ReadLine().Split()

    readLine "Files", (readLine "Find") |> Array.map (fun s -> s.ToLower())

let updateIndex indexMap keyValuePair =
    let k, v = keyValuePair

    match Map.tryFind k indexMap with
        | None     -> Map.add k (Set.singleton v) indexMap
        | Some set -> Map.add k (Set.add v set) indexMap

let buildIndex files =
    let fileData file =
        File.ReadAllText(file).Split() |> Seq.map (fun word -> word.ToLower(), file)

    files |> Seq.collect fileData
          |> Seq.fold updateIndex Map.empty

let searchFiles() =
    let files, terms = inputSearchCriteria()
    let indexes = buildIndex files

    let searchResults = terms |> Seq.map (fun term -> Map.find term indexes)
                              |> Set.intersectMany

    printf "Found in: " ; searchResults |> Set.iter (printf "%s ") ; printfn ""
