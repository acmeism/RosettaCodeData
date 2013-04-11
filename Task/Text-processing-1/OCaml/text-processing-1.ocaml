let input_line ic =
  try Some(input_line ic)
  with End_of_file -> None

let fold_input f ini ic =
  let rec fold ac =
    match input_line ic with
    | Some line -> fold (f ac line)
    | None -> ac
  in
  fold ini

let ic = open_in "readings.txt"

let scan line =
  Scanf.sscanf line "%s\
    \t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\
    \t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\
    \t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\
    \t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\t%d"
    (fun date
         v1  f1  v2  f2  v3  f3  v4  f4  v5  f5  v6  f6
         v7  f7  v8  f8  v9  f9  v10 f10 v11 f11 v12 f12
         v13 f13 v14 f14 v15 f15 v16 f16 v17 f17 v18 f18
         v19 f19 v20 f20 v21 f21 v22 f22 v23 f23 v24 f24 ->
      (date),
      [ (v1,  f1 ); (v2,  f2 ); (v3,  f3 ); (v4,  f4 ); (v5,  f5 ); (v6,  f6 );
        (v7,  f7 ); (v8,  f8 ); (v9,  f9 ); (v10, f10); (v11, f11); (v12, f12);
        (v13, f13); (v14, f14); (v15, f15); (v16, f16); (v17, f17); (v18, f18);
        (v19, f19); (v20, f20); (v21, f21); (v22, f22); (v23, f23); (v24, f24); ])

let tot_file, num_file, _, nodata_max, nodata_maxline =
  fold_input
    (fun (tot_file, num_file, nodata, nodata_max, nodata_maxline) line ->
       let date, datas = scan line in
       let _datas = List.filter (fun (_, flag) -> flag > 0) datas in
       let ok = List.length _datas in
       let tot = List.fold_left (fun ac (value, _) -> ac +. value) 0.0 _datas in
       let nodata, nodata_max, nodata_maxline =
         List.fold_left
             (fun (nodata, nodata_max, nodata_maxline) (_, flag) ->
                if flag <= 0
                then (succ nodata, nodata_max, nodata_maxline)
                else
                  if nodata_max = nodata && nodata > 0
                  then (0, nodata_max, date::nodata_maxline)
                  else if nodata_max < nodata && nodata > 0
                  then (0, nodata, [date])
                  else (0, nodata_max, nodata_maxline)
             )
             (nodata, nodata_max, nodata_maxline) datas in
       Printf.printf "Line: %s" date;
       Printf.printf "  Reject: %2d  Accept: %2d" (24 - ok) ok;
       Printf.printf "\tLine_tot: %8.3f" tot;
       Printf.printf "\tLine_avg: %8.3f\n" (tot /. float ok);
       (tot_file +. tot, num_file + ok, nodata, nodata_max, nodata_maxline))
    (0.0, 0, 0, 0, [])
    ic ;;

close_in ic ;;

Printf.printf "Total    = %f\n" tot_file;
Printf.printf "Readings = %d\n" num_file;
Printf.printf "Average  = %f\n" (tot_file /. float num_file);
Printf.printf "Maximum run(s) of %d consecutive false readings \
               ends at line starting with date(s): %s\n"
               nodata_max (String.concat ", " nodata_maxline);
