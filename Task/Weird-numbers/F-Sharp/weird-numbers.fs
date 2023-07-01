let divisors n = [1..n/2] |> List.filter (fun x->n % x = 0)

let abundant (n:int) divs = Seq.sum(divs) > n

let rec semiperfect (n:int) (divs:List<int>) =
    if divs.Length > 0 then
        let h = divs.Head
        let t = divs.Tail
        if n < h then
            semiperfect n t
        else
            n = h || (semiperfect (n - h) t) || (semiperfect n t)
    else false

let weird n =
    let d = divisors n
    if abundant n d then
        not(semiperfect n d)
    else
        false

[<EntryPoint>]
let main _ =
    let mutable i = 1
    let mutable count = 0
    while (count < 25) do
        if (weird i) then
            count <- count + 1
            printf "%d -> %d\n" count i
        i <- i + 1

    0 // return an integer exit code
