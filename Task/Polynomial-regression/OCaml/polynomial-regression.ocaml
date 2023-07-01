open Base
open Stdio

let mean fa =
  let open Float in
  (Array.reduce_exn fa ~f:(+)) / (of_int (Array.length fa))

let regression xs ys =
  let open Float in
  let xm = mean xs in
  let ym = mean ys in
  let x2m = Array.map xs ~f:(fun x -> x * x) |> mean in
  let x3m = Array.map xs ~f:(fun x -> x * x * x) |> mean in
  let x4m = Array.map xs ~f:(fun x -> let x2 = x * x in x2 * x2) |> mean in
  let xzipy = Array.zip_exn xs ys in
  let xym = Array.map xzipy ~f:(fun (x, y) -> x * y) |> mean in
  let x2ym = Array.map xzipy ~f:(fun (x, y) -> x * x * y) |> mean in

  let sxx = x2m - xm * xm in
  let sxy = xym - xm * ym in
  let sxx2 = x3m - xm * x2m in
  let sx2x2 = x4m - x2m * x2m in
  let sx2y = x2ym - x2m * ym in

  let b = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2) in
  let c = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2) in
  let a = ym - b * xm - c * x2m in

  let abc xx = a + b * xx + c * xx * xx in

  printf "y = %.1f + %.1fx + %.1fx^2\n\n" a b c;
  printf " Input  Approximation\n";
  printf " x   y     y1\n";
  Array.iter xzipy ~f:(fun (xi, yi) ->
    printf "%2g %3g  %5.1f\n" xi yi (abc xi)
  )

let () =
  let x = Array.init 11 ~f:Float.of_int in
  let y = [| 1.; 6.; 17.; 34.; 57.; 86.; 121.; 162.; 209.; 262.; 321. |] in
  regression x y
