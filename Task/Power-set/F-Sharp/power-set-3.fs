let pow xs =
    let mutable subs = [[]]
    for x in xs do
        subs <- [for s in subs do yield! [s;x::s]]
    subs
