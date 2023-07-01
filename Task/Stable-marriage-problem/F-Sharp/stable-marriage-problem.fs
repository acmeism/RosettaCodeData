let menPrefs =
  Map.ofList
            ["abe",  ["abi";"eve";"cath";"ivy";"jan";"dee";"fay";"bea";"hope";"gay"];
             "bob",  ["cath";"hope";"abi";"dee";"eve";"fay";"bea";"jan";"ivy";"gay"];
             "col",  ["hope";"eve";"abi";"dee";"bea";"fay";"ivy";"gay";"cath";"jan"];
             "dan",  ["ivy";"fay";"dee";"gay";"hope";"eve";"jan";"bea";"cath";"abi"];
             "ed",   ["jan";"dee";"bea";"cath";"fay";"eve";"abi";"ivy";"hope";"gay"];
             "fred", ["bea";"abi";"dee";"gay";"eve";"ivy";"cath";"jan";"hope";"fay"];
             "gav",  ["gay";"eve";"ivy";"bea";"cath";"abi";"dee";"hope";"jan";"fay"];
             "hal",  ["abi";"eve";"hope";"fay";"ivy";"cath";"jan";"bea";"gay";"dee"];
             "ian",  ["hope";"cath";"dee";"gay";"bea";"abi";"fay";"ivy";"jan";"eve"];
             "jon",  ["abi";"fay";"jan";"gay";"eve";"bea";"dee";"cath";"ivy";"hope"];
            ]

let womenPrefs =
   Map.ofList
              ["abi",  ["bob";"fred";"jon";"gav";"ian";"abe";"dan";"ed";"col";"hal"];
               "bea",  ["bob";"abe";"col";"fred";"gav";"dan";"ian";"ed";"jon";"hal"];
               "cath", ["fred";"bob";"ed";"gav";"hal";"col";"ian";"abe";"dan";"jon"];
               "dee",  ["fred";"jon";"col";"abe";"ian";"hal";"gav";"dan";"bob";"ed"];
               "eve",  ["jon";"hal";"fred";"dan";"abe";"gav";"col";"ed";"ian";"bob"];
               "fay",  ["bob";"abe";"ed";"ian";"jon";"dan";"fred";"gav";"col";"hal"];
               "gay",  ["jon";"gav";"hal";"fred";"bob";"abe";"col";"ed";"dan";"ian"];
               "hope", ["gav";"jon";"bob";"abe";"ian";"dan";"hal";"ed";"col";"fred"];
               "ivy",  ["ian";"col";"hal";"gav";"fred";"bob";"abe";"ed";"jon";"dan"];
               "jan",  ["ed";"hal";"gav";"abe";"bob";"jon";"col";"ian";"fred";"dan"];
              ]

let men = menPrefs |> Map.toList |> List.map fst |> List.sort
let women = womenPrefs |> Map.toList |> List.map fst |> List.sort


type Configuration =
 {
   proposed: Map<string,string list>; // man -> list of women
   wifeOf: Map<string, string>; // man -> woman
   husbandOf: Map<string, string>;  // woman -> man
 }


// query functions

let isFreeMan config man = config.wifeOf.TryFind man = None

let isFreeWoman config woman = config.husbandOf.TryFind woman = None

let hasProposedTo config man woman =
  defaultArg (config.proposed.TryFind(man)) []
  |> List.exists ((=) woman)

// helper
let negate f = fun x -> not (f x)

// returns those 'women' who 'man' has not proposed to before
let notProposedBy config man women = List.filter (negate (hasProposedTo config man)) women

let prefers (prefs:Map<string,string list>) w m1 m2 =
  let order = prefs.[w]
  let m1i = List.findIndex ((=) m1) order
  let m2i = List.findIndex ((=) m2) order
  m1i < m2i

let womanPrefers = prefers womenPrefs
let manPrefers = prefers menPrefs

// returns the women that m likes better than his current fiancée
let preferredWomen config m =
  let w = config.wifeOf.[m]
  women
  |> List.filter (fun w' -> manPrefers m w' w)  // '

// whether there is a woman who m likes better than his current fiancée
// and who also likes him better than her current fiancé
let prefersAWomanWhoAlsoPrefersHim config m =
  preferredWomen config m
  |> List.exists (fun w -> womanPrefers w m config.husbandOf.[w])

let isStable config =
  not (List.exists (prefersAWomanWhoAlsoPrefersHim config) men)


// modifiers (return new configurations)

let engage config man woman =
  { config with wifeOf = config.wifeOf.Add(man, woman);
                husbandOf = config.husbandOf.Add(woman, man) }

let breakOff config man =
  let woman = config.wifeOf.[man]
  { config with wifeOf = config.wifeOf.Remove(man);
                husbandOf = config.husbandOf.Remove(woman) }

let propose config m w =
  // remember the proposition
  let proposedByM = defaultArg (config.proposed.TryFind m) []
  let proposed' = config.proposed.Add(m, w::proposedByM) // '
  let config = { config with proposed = proposed'}  // '
  // actually try to engage
  if isFreeWoman config w then engage config m w
  else
    let m' = config.husbandOf.[w] // '
    if womanPrefers w m m' then // '
      let config = breakOff config m' // '
      engage config m w
    else
      config

// do one step of the algorithm; returns None if no more steps are possible
let step config : Configuration option =
  let freeMen = men |> List.filter (isFreeMan config)
  let menWhoCanPropose =
    freeMen |>
    List.filter (fun man -> (notProposedBy config man women) <> [] )
  match menWhoCanPropose with
  | [] -> None
  | m::_ -> let unproposedByM = menPrefs.[m] |> notProposedBy config m
            // w is automatically the highest ranked because menPrefs.[m] is the source
            let w = List.head unproposedByM
            Some( propose config m w )

let rec loop config =
  match step config with
  | None -> config
  | Some config' -> loop config' // '


// find solution and print it
let solution = loop { proposed = Map.empty<string, string list>;
                      wifeOf = Map.empty<string, string>;
                      husbandOf = Map.empty<string, string> }

for woman, man in Map.toList solution.husbandOf do
  printfn "%s is engaged to %s" woman man

printfn "Solution is stable: %A" (isStable solution)


// create unstable configuration by perturbing the solution
let perturbed =
  let gal0 = women.[0]
  let gal1 = women.[1]
  let guy0 = solution.husbandOf.[gal0]
  let guy1 = solution.husbandOf.[gal1]
  { solution with wifeOf = solution.wifeOf.Add( guy0, gal1 ).Add( guy1, gal0 );
                  husbandOf = solution.husbandOf.Add( gal0, guy1 ).Add( gal1, guy0 ) }

printfn "Perturbed is stable: %A" (isStable perturbed)
