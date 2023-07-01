let rec quickselect k = function
   [] -> failwith "empty"
 | x :: xs -> let ys, zs = List.partition ((>) x) xs in
              let l = List.length ys in
              if k < l then
                quickselect k ys
              else if k > l then
                quickselect (k-l-1) zs
              else
                x
