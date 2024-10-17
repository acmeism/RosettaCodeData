(* Task : Circles of given radius through two points *)

(* Types to make code even more readable *)
type point = float * float
type radius = float
type circle = Circle of radius * point
type circ_output =
    NoSolution
    | OneSolution of circle
    | TwoSolutions of circle * circle
    | InfiniteSolutions
;;

(* Actual function *)
let circles_2points_radius (x1, y1 : point) (x2, y2 : point) (r : radius) =
    let (dx, dy) = (x2 -. x1, y2 -. y1) in
    let dist_sq = dx *. dx +. dy *. dy in
    match dist_sq, r with
    (* Edge case - point circles *)
    | 0., 0. -> OneSolution (Circle (r, (x1, y1)))
    (* Edge case - coinciding points *)
    | 0., _ -> InfiniteSolutions
    | _ ->
        let side_len_sq = r *. r -. dist_sq /. 4. in
        let midp = ((x1 +. x2) *. 0.5, (y1 +. y2) *. 0.5) in
        (* Points are too far apart; same whether r = 0 or not *)
        if side_len_sq < 0. then NoSolution
        (* Points are on diameter *)
        else if side_len_sq = 0. then OneSolution (Circle (r, midp))
        else
            (* A right-angle triangle is made with the radius as hyp, dist/2 as one side *)
            let side_len = sqrt (r *. r -. dist_sq /. 4.) in
            let dist = sqrt dist_sq in
            (*  A 90-deg rotation of a vector (x, y) is obtained by either (y, -x) or (-y, x)
                We need both, so pick one and the other is its negative.
            *)
            let (vx, vy) = (-. dy *. side_len /. dist, dx *. side_len /. dist) in
            let c1 = Circle (r, (fst midp +. vx, snd midp +. vy)) in
            let c2 = Circle (r, (fst midp -. vx, snd midp -. vy)) in
            TwoSolutions (c1, c2)
;;

(* Relevant tests and printing *)
let tests = [
    (0.1234, 0.9876), (0.8765, 0.2345), 2.0;
    (0.0000, 2.0000), (0.0000, 0.0000), 1.0;
    (0.1234, 0.9876), (0.1234, 0.9876), 2.0;
    (0.1234, 0.9876), (0.8765, 0.2345), 0.5;
    (0.1234, 0.9876), (0.1234, 0.9876), 0.0;
] ;;

let format_output (out : circ_output) = match out with
    | NoSolution -> print_endline "No solution"
    | OneSolution (Circle (_, (x, y))) -> Printf.printf "One solution: (%.6f, %.6f)\n" x y
    | TwoSolutions (Circle (_, (x1, y1)), Circle (_, (x2, y2))) ->
        Printf.printf "Two solutions: (%.6f, %.6f) and (%.6f, %.6f)\n" x1 y1 x2 y2
    | InfiniteSolutions -> print_endline "Infinite solutions"
;;

let _ =
    List.iter
    (fun (a, b, c) -> circles_2points_radius a b c |> format_output)
    tests
;;
