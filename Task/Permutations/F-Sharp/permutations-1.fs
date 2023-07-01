let rec insert left x right = seq {
    match right with
    | [] -> yield left @ [x]
    | head :: tail ->
        yield left @ [x] @ right
        yield! insert (left @ [head]) x tail
    }

let rec perms permute =
    seq {
        match permute with
        | [] -> yield []
        | head :: tail -> yield! Seq.collect (insert [] head) (perms tail)
    }

[<EntryPoint>]
let main argv =
    perms (Seq.toList argv)
    |> Seq.iter (fun x -> printf "%A\n" x)
    0
