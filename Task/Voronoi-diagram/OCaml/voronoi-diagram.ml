let n_sites = 220

let size_x = 640
let size_y = 480

let sq2 ~x ~y =
  (x * x + y * y)

let rand_int_range a b =
  a + Random.int (b - a + 1)

let nearest_site ~site ~x ~y =
  let ret = ref 0 in
  let dist = ref 0 in
  Array.iteri (fun k (sx, sy) ->
    let d = sq2 (x - sx) (y - sy) in
    if k = 0 || d < !dist then begin
      dist := d;
      ret := k;
    end
  ) site;
  !ret

let gen_map ~site ~rgb =
  let nearest = Array.make (size_x * size_y) 0 in
  let buf = Bytes.create (3 * size_x * size_y) in

  for y = 0 to pred size_y do
    for x = 0 to pred size_x do
      nearest.(y * size_x + x) <-
        nearest_site ~site ~x ~y;
    done;
  done;

  for i = 0 to pred (size_y * size_x) do
    let j = i * 3 in
    let r, g, b = rgb.(nearest.(i)) in
    Bytes.set buf (j+0) (char_of_int r);
    Bytes.set buf (j+1) (char_of_int g);
    Bytes.set buf (j+2) (char_of_int b);
  done;

  Printf.printf "P6\n%d %d\n255\n" size_x size_y;
  print_bytes buf;
;;

let () =
  Random.self_init ();
  let site =
    Array.init n_sites (fun i ->
      (Random.int size_x,
       Random.int size_y))
  in
  let rgb =
    Array.init n_sites (fun i ->
      (rand_int_range 160 255,
       rand_int_range  40 160,
       rand_int_range  20 140))
  in
  gen_map ~site ~rgb
