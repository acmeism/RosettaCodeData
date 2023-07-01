let list_add_last this lst =
  List.rev (this :: (List.rev lst))

let () =
  let csv = Csv.load "data.csv" in
  let fields, data =
    (List.hd csv,
     List.tl csv)
  in
  let fields =
    list_add_last "SUM" fields
  in
  let sums =
    List.map (fun row ->
      let tot = List.fold_left (fun tot this -> tot + int_of_string this) 0 row in
      list_add_last (string_of_int tot) row
    ) data
  in
  Csv.output_all (Csv.to_channel stdout) (fields :: sums)
