> let gen n =
    let xs = Array.create n [1] in
    for i=1 to n-1 do
      xs.(i) <- seeAndSay(xs.(i-1), [])
    done;
    xs;;
val gen : int -> int list array = <fun>

> gen 10;;
- : int list array =
  [|[1]; [1; 1]; [2; 1]; [1; 2; 1; 1]; [1; 1; 1; 2; 2; 1]; [3; 1; 2; 2; 1; 1];
    [1; 3; 1; 1; 2; 2; 2; 1]; [1; 1; 1; 3; 2; 1; 3; 2; 1; 1];
    [3; 1; 1; 3; 1; 2; 1; 1; 1; 3; 1; 2; 2; 1];
    [1; 3; 2; 1; 1; 3; 1; 1; 1; 2; 3; 1; 1; 3; 1; 1; 2; 2; 1; 1]|]
