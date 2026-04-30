//Sort a list of object identifiers. Nigel Galloway: March 9th., 2026
let inD=["1.3.6.1.4.1.11.2.17.19.3.4.0.10";
         "1.3.6.1.4.1.11.2.17.5.2.0.79";
         "1.3.6.1.4.1.11.2.17.19.3.4.0.4";
         "1.3.6.1.4.1.11150.3.4.0.1";
         "1.3.6.1.4.1.11.2.17.19.3.4.0.1";
         "1.3.6.1.4.1.11150.3.4.0"]
inD|>List.sortBy(fun n->n.Split('.')|>Array.map(int)|>List.ofArray)|>List.iter(printfn "%s")
