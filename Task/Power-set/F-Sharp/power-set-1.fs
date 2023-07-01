let subsets xs = List.foldBack (fun x rest -> rest @ List.map (fun ys -> x::ys) rest) xs [[]]
