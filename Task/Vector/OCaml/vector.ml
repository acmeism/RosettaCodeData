module Vector =
  struct
    type t = { x : float; y : float }
    let make x y = { x; y }
    let add a b = { x = a.x +. b.x; y = a.y +. b.y }
    let sub a b = { x = a.x -. b.x; y = a.y -. b.y }
    let mul a n = { x = a.x *. n; y = a.y *. n }
    let div a n = { x = a.x /. n; y = a.y /. n }

    let to_string {x; y} = Printf.sprintf "(%F, %F)" x y

    let ( + ) = add
    let ( - ) = sub
    let ( * ) = mul
    let ( / ) = div
  end

open Printf

let test () =
  let a, b = Vector.make 5. 7., Vector.make 2. 3. in
  printf "a:    %s\n" (Vector.to_string a);
  printf "b:    %s\n" (Vector.to_string b);
  printf "a+b:  %s\n" Vector.(a + b |> to_string);
  printf "a-b:  %s\n" Vector.(a - b |> to_string);
  printf "a*11: %s\n" Vector.(a * 11. |> to_string);
  printf "a/2:  %s\n" Vector.(a / 2. |> to_string)
