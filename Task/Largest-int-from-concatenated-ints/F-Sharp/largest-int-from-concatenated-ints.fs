// Form largest integer which is a permutation from a list of integers. Nigel Galloway: March 21st., 2018
let fN g = List.map (string) g |> List.sortWith(fun n g->if n+g<g+n then 1 else -1) |> System.String.Concat
