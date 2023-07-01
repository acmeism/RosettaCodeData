open System

let union s1 s2 =
    fun x -> (s1 x) || (s2 x);

let difference s1 s2 =
    fun x -> (s1 x) && not (s2 x)

let intersection s1 s2 =
    fun x -> (s1 x) && (s2 x)

[<EntryPoint>]
let main _ =
    //test set union
    let u1 = union (fun x -> 0.0 < x && x <= 1.0) (fun x -> 0.0 <= x && x < 2.0)
    assert (u1 0.0)
    assert (u1 1.0)
    assert (not (u1 2.0))

    //test set difference
    let d1 = difference (fun x -> 0.0 <= x && x < 3.0) (fun x -> 0.0 < x && x < 1.0)
    assert (d1 0.0)
    assert (not (d1 0.5))
    assert (d1 1.0)
    assert (d1 2.0)

    let d2 = difference (fun x -> 0.0 <= x && x < 3.0) (fun x -> 0.0 <= x && x <= 1.0)
    assert (not (d2 0.0))
    assert (not (d2 1.0))
    assert (d2 2.0)

    let d3 = difference (fun x -> 0.0 <= x && x <= Double.PositiveInfinity) (fun x -> 1.0 <= x && x <= 2.0)
    assert (d3 0.0)
    assert (not (d3 1.5))
    assert (d3 3.0)

    //test set intersection
    let i1 = intersection (fun x -> 0.0 <= x && x < 2.0) (fun x -> 1.0 < x && x <= 2.0)
    assert (not (i1 0.0))
    assert (not (i1 1.0))
    assert (not (i1 2.0))

    0 // return an integer exit code
