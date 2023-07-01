// State name puzzle. Nigel Galloway: February 9th., 2023
let states=["Alabama"; "Alaska"; "Arizona"; "Arkansas"; "California"; "Colorado"; "Connecticut"; "Delaware"; "Florida"; "Georgia"; "Hawaii"; "Idaho"; "Illinois"; "Indiana"; "Iowa"; "Kansas"; "Kentucky"; "Louisiana"; "Maine"; "Maryland"; "Massachusetts"; "Michigan"; "Minnesota"; "Mississippi"; "Missouri"; "Montana"; "Nebraska"; "Nevada"; "New Hampshire"; "New Jersey"; "New Mexico"; "New York"; "North Carolina"; "North Dakota"; "Ohio"; "Oklahoma"; "Oregon"; "Pennsylvania"; "Rhode Island"; "South Carolina"; "South Dakota"; "Tennessee"; "Texas"; "Utah"; "Vermont"; "Virginia"; "Washington"; "West Virginia"; "Wisconsin"; "Wyoming"; "New Kory"; "Wen Kory"; "York New"; "Kory New"; "New Kory"]|>List.distinct
let fN(i,g)(e,l)=let n=Array.zeroCreate<int>256
                 let fN i g=n[g]<-n[g]+i
                 let fG n g=(g:string).ToLower().ToCharArray()|>Array.iter(fun g->fN n (int g))
                 fG 1 i; fG 1 g; fG -1 e; fG -1 l; n|>Array.forall((=)0)
let n=states|>List.allPairs states|>List.filter(fun(n,g)->n<g)|>List.groupBy(fun(n,g)->n.Length+g.Length)
let g=n|>List.map(fun(_,n)->n|>List.allPairs n|>List.filter(fun((n,g),(n',g'))->(n,g)<(n',g') && n<>n' && n<>g' && g<>n' && g<>g' && fN(n,g)(n',g')))|>List.filter(List.isEmpty>>not)
g|>List.iter(List.iter(fun((i,g),(e,l))->printfn $"%s{i},%s{g}->%s{e},%s{l}"))
