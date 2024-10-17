module A = Archimedes

let y = [|2.7; 2.8; 31.4; 38.1; 58.0; 76.2; 100.5; 130.0; 149.3; 180.0|]

let () =
  let vp = A.init [] in
  A.Axes.box vp;
  A.set_color vp A.Color.red;
  A.Array.y vp y;
  A.close vp
