let expMod a b n =
    let rec loop a b c =
        if b = 0I then c else
            loop (a*a%n) (b>>>1) (if b&&&1I = 0I then c else c*a%n)
    loop a b 1I

[<EntryPoint>]
let main argv =
    let a = 2988348162058574136915891421498819466320163312926952423791023078876139I
    let b = 2351399303373464486466122544523690094744975233415544072992656881240319I
    printfn "%A" (expMod a b (10I**40))    // -> 1527229998585248450016808958343740453059
    0
