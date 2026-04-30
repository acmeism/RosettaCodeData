[1..100] |> List.fold (fun doors pass->List.mapi (fun i x->if ((i + 1) % pass)=0 then not x else x) doors) (List.init 100 (fun _->false))
