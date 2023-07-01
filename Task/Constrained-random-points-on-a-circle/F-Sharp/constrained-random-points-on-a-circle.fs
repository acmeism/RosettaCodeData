module CirclePoints =
    let main args =
        let rnd = new System.Random()
        let rand size = rnd.Next(size) - size/2
        let size = 30
        let gen n =
            let rec f (x,y) =
                let t = (int (sqrt (float (x*x + y*y)) ))
                if 10 <= t && t <= 15 then (x,y) else f (rand size, rand size)
            f (rand size, rand size)
        let plot = Array.init 100 (fun n -> gen n)
        for row in 0 .. size-1 do
            let chars = Array.create (size+1) ' '
            Array.choose (fun (x,y) -> if y = (row-size/2) then Some(x) else None) plot
            |> Array.iter (fun x -> chars.[x+size/2] <- 'o')
            printfn "%s" (new string(chars))
        0

#if INTERACTIVE
CirclePoints.main fsi.CommandLineArgs
#else
[<EntryPoint>]
let main args = CirclePoints.main args
#endif
