let emboss img =
  let kernel = [|
    [| -2.; -1.;  0. |];
    [| -1.;  1.;  1. |];
    [|  0.;  1.;  2. |];
  |] in
  convolve_value ~img ~kernel ~divisor:1.0 ~offset:0.0;
;;

let sharpen img =
  let kernel = [|
    [| -1.; -1.; -1. |];
    [| -1.;  9.; -1. |];
    [| -1.; -1.; -1. |];
  |] in
  convolve_value ~img ~kernel ~divisor:1.0 ~offset:0.0;
;;

let sobel_emboss img =
  let kernel = [|
    [| -1.; -2.; -1. |];
    [|  0.;  0.;  0. |];
    [|  1.;  2.;  1. |];
  |] in
  convolve_value ~img ~kernel ~divisor:1.0 ~offset:0.5;
;;

let box_blur img =
  let kernel = [|
    [|  1.;  1.;  1. |];
    [|  1.;  1.;  1. |];
    [|  1.;  1.;  1. |];
  |] in
  convolve_value ~img ~kernel ~divisor:9.0 ~offset:0.0;
;;
