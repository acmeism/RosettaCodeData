let avg (a:float) (v:float) n =
    a + (1. / ((float n) + 1.)) * (v - a)

let mean_series list =
    let a, _ = List.fold_left (fun (a, n) h -> avg a (float h) n, n + 1) (0., 0) list in
    a
