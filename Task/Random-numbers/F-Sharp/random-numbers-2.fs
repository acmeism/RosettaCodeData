let gaussianRand count =
    let o = new System.Random()
    let pi = System.Math.PI
    let gaussrnd =
        (fun _ -> 1. + 0.5 * sqrt(-2. * log(o.NextDouble())) * cos(2. * pi * o.NextDouble()))
    [ for i in {0 .. (int count)} -> gaussrnd() ]
