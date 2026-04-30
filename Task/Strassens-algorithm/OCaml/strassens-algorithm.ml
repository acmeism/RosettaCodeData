(* Matrix multiplication using Strassen's algorithm in OCaml *)

type matrix = float array array

type shape = {
  rows : int;
  cols : int;
}

(* Get the shape of a matrix *)
let shape m =
  let rows = Array.length m in
  let cols = if rows = 0 then 0 else Array.length m.(0) in
  { rows; cols }

(* Create a matrix from a list of lists *)
let matrix_of_lists lists =
  Array.of_list (List.map Array.of_list lists)

(* Convert matrix to list of lists for printing *)
let lists_of_matrix m =
  Array.to_list (Array.map Array.to_list m)

(* Matrix addition *)
let add_matrix a b =
  let { rows; cols } = shape a in
  let { rows = b_rows; cols = b_cols } = shape b in
  assert (rows = b_rows && cols = b_cols);
  Array.init rows (fun i ->
    Array.init cols (fun j -> a.(i).(j) +. b.(i).(j)))

(* Matrix subtraction *)
let sub_matrix a b =
  let { rows; cols } = shape a in
  let { rows = b_rows; cols = b_cols } = shape b in
  assert (rows = b_rows && cols = b_cols);
  Array.init rows (fun i ->
    Array.init cols (fun j -> a.(i).(j) -. b.(i).(j)))

(* Naive matrix multiplication *)
let dot_product a b =
  let a_shape = shape a in
  let b_shape = shape b in
  assert (a_shape.cols = b_shape.rows);

  Array.init a_shape.rows (fun i ->
    Array.init b_shape.cols (fun j ->
      let sum = ref 0.0 in
      for k = 0 to a_shape.cols - 1 do
        sum := !sum +. (a.(i).(k) *. b.(k).(j))
      done;
      !sum))

(* Extract a submatrix *)
let submatrix m start_row end_row start_col end_col =
  Array.init (end_row - start_row) (fun i ->
    Array.init (end_col - start_col) (fun j ->
      m.(start_row + i).(start_col + j)))

(* Combine four submatrices into a single matrix *)
let block_matrix c11 c12 c21 c22 =
  let p = Array.length c11 in
  let result = Array.make_matrix (2 * p) (2 * p) 0.0 in

  (* Copy c11 to top-left *)
  for i = 0 to p - 1 do
    for j = 0 to p - 1 do
      result.(i).(j) <- c11.(i).(j)
    done
  done;

  (* Copy c12 to top-right *)
  for i = 0 to p - 1 do
    for j = 0 to p - 1 do
      result.(i).(p + j) <- c12.(i).(j)
    done
  done;

  (* Copy c21 to bottom-left *)
  for i = 0 to p - 1 do
    for j = 0 to p - 1 do
      result.(p + i).(j) <- c21.(i).(j)
    done
  done;

  (* Copy c22 to bottom-right *)
  for i = 0 to p - 1 do
    for j = 0 to p - 1 do
      result.(p + i).(p + j) <- c22.(i).(j)
    done
  done;

  result

(* Check if a number is a power of 2 *)
let is_power_of_2 n =
  n > 0 && (n land (n - 1)) = 0

(* Strassen's matrix multiplication *)
let rec strassen a b =
  let a_shape = shape a in
  let b_shape = shape b in
  let rows = a_shape.rows in
  let cols = a_shape.cols in

  assert (rows = cols);  (* matrices must be square *)
  assert (a_shape.rows = b_shape.rows && a_shape.cols = b_shape.cols);  (* same shape *)
  assert (is_power_of_2 rows);  (* size must be power of 2 *)

  if rows = 1 then
    dot_product a b
  else
    let p = rows / 2 in

    (* Partition matrix a *)
    let a11 = submatrix a 0 p 0 p in
    let a12 = submatrix a 0 p p rows in
    let a21 = submatrix a p rows 0 p in
    let a22 = submatrix a p rows p rows in

    (* Partition matrix b *)
    let b11 = submatrix b 0 p 0 p in
    let b12 = submatrix b 0 p p rows in
    let b21 = submatrix b p rows 0 p in
    let b22 = submatrix b p rows p rows in

    (* Compute the 7 products *)
    let m1 = strassen (add_matrix a11 a22) (add_matrix b11 b22) in
    let m2 = strassen (add_matrix a21 a22) b11 in
    let m3 = strassen a11 (sub_matrix b12 b22) in
    let m4 = strassen a22 (sub_matrix b21 b11) in
    let m5 = strassen (add_matrix a11 a12) b22 in
    let m6 = strassen (sub_matrix a21 a11) (add_matrix b11 b12) in
    let m7 = strassen (sub_matrix a12 a22) (add_matrix b21 b22) in

    (* Compute the result submatrices *)
    let c11 = add_matrix (sub_matrix (add_matrix m1 m4) m5) m7 in
    let c12 = add_matrix m3 m5 in
    let c21 = add_matrix m2 m4 in
    let c22 = add_matrix (sub_matrix (add_matrix m1 m3) m2) m6 in

    block_matrix c11 c12 c21 c22

(* Round matrix elements to specified decimal places *)
let round_matrix ?(ndigits=0) m =
  let factor = 10.0 ** (float_of_int ndigits) in
  Array.map (Array.map (fun x ->
    Float.round (x *. factor) /. factor)) m

(* Pretty print a matrix *)
let print_matrix m =
  let lists = lists_of_matrix m in
  print_string "[";
  List.iteri (fun i row ->
    if i > 0 then print_string "; ";
    print_string "[";
    List.iteri (fun j x ->
      if j > 0 then print_string "; ";
      Printf.printf "%.6g" x) row;
    print_string "]") lists;
  print_endline "]"

(* Example usage *)
let examples () =
  let a = matrix_of_lists [
    [1.0; 2.0];
    [3.0; 4.0]
  ] in

  let b = matrix_of_lists [
    [5.0; 6.0];
    [7.0; 8.0]
  ] in

  let c = matrix_of_lists [
    [1.0; 1.0; 1.0; 1.0];
    [2.0; 4.0; 8.0; 16.0];
    [3.0; 9.0; 27.0; 81.0];
    [4.0; 16.0; 64.0; 256.0]
  ] in

  let d = matrix_of_lists [
    [4.0; -3.0; 4.0/.3.0; -1.0/.4.0];
    [-13.0/.3.0; 19.0/.4.0; -7.0/.3.0; 11.0/.24.0];
    [3.0/.2.0; -2.0; 7.0/.6.0; -1.0/.4.0];
    [-1.0/.6.0; 1.0/.4.0; -1.0/.6.0; 1.0/.24.0]
  ] in

  let e = matrix_of_lists [
    [1.0; 2.0; 3.0; 4.0];
    [5.0; 6.0; 7.0; 8.0];
    [9.0; 10.0; 11.0; 12.0];
    [13.0; 14.0; 15.0; 16.0]
  ] in

  let f = matrix_of_lists [
    [1.0; 0.0; 0.0; 0.0];
    [0.0; 1.0; 0.0; 0.0];
    [0.0; 0.0; 1.0; 0.0];
    [0.0; 0.0; 0.0; 1.0]
  ] in

  print_endline "Naive matrix multiplication:";
  print_string "  a * b = "; print_matrix (dot_product a b);
  print_string "  c * d = "; print_matrix (round_matrix (dot_product c d));
  print_string "  e * f = "; print_matrix (dot_product e f);

  print_endline "\nStrassen's matrix multiplication:";
  print_string "  a * b = "; print_matrix (strassen a b);
  print_string "  c * d = "; print_matrix (round_matrix (strassen c d));
  print_string "  e * f = "; print_matrix (strassen e f)

(* Run examples when executed *)
let () = examples ()
