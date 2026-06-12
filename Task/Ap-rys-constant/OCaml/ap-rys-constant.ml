(* Using:
  https://ocaml.org/p/decimal
  https://ocaml.org/p/zarith *)

Decimal.Context.default := Decimal.Context.make ~prec:100 ()

let cubesum (nterms : int) : Decimal.t =
  Array.init nterms ((+) 1)
  |> Array.map Decimal.of_int
  |> Array.map (fun d -> Decimal.(d * d * d))
  |> Array.map Decimal.((/) one)
  |> Array.fold_left Decimal.(+) Decimal.zero

let markov (nterms : int) : Decimal.t =
  let apery_term (k : int) : Decimal.t =
    let num = Z.((fac k) ** 2) in
    let den = Z.( * ) (Z.fac @@ 2 * k) Z.((of_int k) ** 3) in
    let frac = Decimal.(div (of_bigint num) (of_bigint den)) in
    let coeff = Decimal.of_int (if k mod 2 = 1 then +1 else -1) in
    Decimal.(coeff * frac) in
  let five_halves = Decimal.(div (of_int 5) (of_int 2)) in
  List.init nterms (fun n -> apery_term @@ n + 1)
    |> List.fold_left Decimal.(+) Decimal.zero
    |> Decimal.( * ) five_halves

let wedeniwski (nterms : int) : Decimal.t =
  let coeffs = [|126392; 412708; 531578; 336367; 104000; 12463|] in
  let zcoeffs = Array.map Z.of_int coeffs in
  let apery_term (k : int ) : Decimal.t =
    let kz = Z.of_int k in
    let pows = Array.init 6 (fun p -> Z.( ** ) kz (5 - p)) in
    let zfact_cubed = fun z -> Z.(pow (fac z) 3) in
    let num_lhs = [|2 * k + 1; 2 * k; k|]
      |> Array.map zfact_cubed
      |> Array.fold_left Z.( * ) Z.one
      |> Decimal.of_bigint in
    let num_rhs = Array.combine zcoeffs pows
      |> Array.map (fun (c, p) -> Z.( * ) c p)
      |> Array.fold_left Z.(+) Z.zero
      |> Decimal.of_bigint in
    let den = Z.( * ) (zfact_cubed @@ 4 * k + 3) (Z.fac @@ 3 * k + 2)
      |> Decimal.of_bigint in
    let sgn = Decimal.of_int (if k mod 2 = 0 then +1 else -1) in
    Decimal.(sgn * (num_lhs * num_rhs) / den) in
    List.init nterms apery_term
      |> List.fold_left Decimal.(+) Decimal.zero
      |> Decimal.(( * ) (div one (of_int 24)))

let () =
  cubesum 1000
    |> Decimal.to_string
    |> Printf.printf "Naive: %s\n\n";
  markov 158
    |> Decimal.to_string
    |> Printf.printf "Markov: %s\n\n";
  wedeniwski 20
    |> Decimal.to_string
    |> Printf.printf "Wedeniwski: %s\n";
