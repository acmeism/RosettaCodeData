let n_arrays_iter ~f = function
  | [] -> ()
  | x::xs as al ->
      let len = Array.length x in
      let b = List.for_all (fun a -> Array.length a = len) xs in
      if not b then invalid_arg "n_arrays_iter: arrays of different
length";
      for i = 0 to pred len do
        let ai = List.map (fun a -> a.(i)) al in
        f ai
      done
