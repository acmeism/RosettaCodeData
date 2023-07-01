let rec splitToFives list =
    match list with
        | a::b::c::d::e::tail ->
            ([a;b;c;d;e])::(splitToFives tail)
        | [] -> []
        | _ ->
                let left = 5 - List.length (list)
                let last = List.append list (List.init left (fun _ -> System.Double.PositiveInfinity) )
                in [last]

let medianFromFives =
    List.map ( fun (i:float list) ->
        List.nth (List.sort i) 2 )

let start l =
    let rec magicFives list k =
        if List.length(list) <= 10 then
            List.nth (List.sort list) (k-1)
        else
            let s = splitToFives list
            let M = medianFromFives s
            let m = magicFives M (int(System.Math.Ceiling((float(List.length M))/2.)))
            let (ll,lg) = List.partition ( fun i -> i < m ) list
            let (le,lg) = List.partition ( fun i -> i = m ) lg
            in
               if (List.length ll >= k) then
                    magicFives ll k
               else if (List.length ll + List.length le >= k ) then m
               else
                    magicFives lg (k-(List.length ll)-(List.length le))
    in
        let len = List.length l in
        if (len % 2 = 1) then
            magicFives l ((len+1)/2)
        else
            let a = magicFives l (len/2)
            let b = magicFives l ((len/2)+1)
            in (a+b)/2.


let z = [1.;5.;2.;8.;7.;2.]
start z
let z' = [1.;5.;2.;8.;7.]
start z'
