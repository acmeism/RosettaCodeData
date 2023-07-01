let deltaBearing (b1:double) (b2:double) =
    let r = (b2 - b1) % 360.0;
    if r > 180.0 then
        r - 360.0
    elif r < -180.0 then
        r + 360.0
    else
        r

[<EntryPoint>]
let main _ =
    printfn "%A" (deltaBearing      20.0                  45.0)
    printfn "%A" (deltaBearing     -45.0                  45.0)
    printfn "%A" (deltaBearing     -85.0                  90.0)
    printfn "%A" (deltaBearing     -95.0                  90.0)
    printfn "%A" (deltaBearing     -45.0                 125.0)
    printfn "%A" (deltaBearing     -45.0                 145.0)
    printfn "%A" (deltaBearing      29.4803              -88.6381)
    printfn "%A" (deltaBearing     -78.3251             -159.036)
    printfn "%A" (deltaBearing  -70099.74233810938     29840.67437876723)
    printfn "%A" (deltaBearing -165313.6666297357      33693.9894517456)
    printfn "%A" (deltaBearing    1174.8380510598456 -154146.66490124757)
    printfn "%A" (deltaBearing   60175.77306795546     42213.07192354373)
    0 // return an integer exit code
