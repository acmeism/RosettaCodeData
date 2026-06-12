// Conjugate a Latin Verb. Nigel Galloway: September 17th., 2021
let myLatin (n:string)=printfn "Rogatus sum iungere verbum %s" n
                       match n.Length>3,n.[-3..]="are" with
                        (false,_)|(_,false)->printfn "    facis quod"
                       |_->["o";"as";"at";"amus";"atis";"ant"]|>List.iter(fun g->printfn "    %s%s" n.[0.. -4] g)
myLatin "amare"
myLatin "creo"
