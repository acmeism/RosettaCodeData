open Xlib

let () =
  let d = xOpenDisplay "" in
  let s = xDefaultScreen d in
  let w = xCreateSimpleWindow d (xRootWindow d s) 10 10 100 100 1
                                (xBlackPixel d s) (xWhitePixel d s) in
  xSelectInput d w [KeyPressMask];
  xMapWindow d w;
  let _ = xNextEventFun d in  (* waits any key-press event *)
  xCloseDisplay d;
;;
