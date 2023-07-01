let zig (x1,y1) (x2,y2) = (x1+x2+y1-y2)/2, (x2-x1+y1+y2)/2
let zag (x1,y1) (x2,y2) = (x1+x2-y1+y2)/2, (x1-x2+y1+y2)/2

let rec dragon p1 p2 p3 n =
   if n = 0 then [p1;p2] else
   (dragon p1 (zig p1 p2) p2 (n-1)) @ (dragon p2 (zag p2 p3) p3 (n-1))

let _ =
   let top = Tk.openTk() in
   let c = Canvas.create ~width:430 ~height:300 top in
   Tk.pack [c];
   let p1, p2 = (100, 100), (356,100) in
   let points = dragon p1 (zig p1 p2) p2 15 in
   ignore (Canvas.create_line ~xys: points c);
   Tk.mainLoop ()
