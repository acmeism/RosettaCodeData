class point x y =
  object
    val mutable x = x
    val mutable y = y
    method print = Printf.printf "(%d, %d)\n" x y
    method dance =
      x <- x + Random.int 3 - 1;
      y <- y + Random.int 3 - 1
  end

type evil_point {
  blah : int;
  blah2 : int;
  mutable x : int;
  mutable y : int;
}

let evil_reset p =
  let ep = Obj.magic p in
  ep.x <- 0;
  ep.y <- 0

let () =
  let p = new point 0 0 in
  p#print;
  p#dance;
  p#print;
  p#dance;
  p#print;
  let (_, _, x, y) : int * int * int * int = Obj.magic p in
  Printf.printf "Broken coord: (%d, %d)\n" x y;
  evil_reset p
  p#print
