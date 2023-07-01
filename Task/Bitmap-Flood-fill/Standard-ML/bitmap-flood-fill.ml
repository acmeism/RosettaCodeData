(* For simplicity, we're going to fill black-and-white images. Nothing
 * fundamental would change if we used more colors. *)
datatype color = Black | White
(* Represent an image as a 2D mutable array of pixels, since flood-fill
 * is naturally an imperative algorithm. *)
type image = color array array

(* Helper functions to construct images for testing. Map 0 -> White
 * and 1 -> Black so we can write images concisely as lists. *)
fun intToColor 0 = White
  | intToColor _ = Black

fun listToImage (LL : int list list) : image =
    Array.tabulate(List.length LL,
     fn i => Array.tabulate (List.length (hd LL),
       fn j => intToColor(List.nth(List.nth(LL,i),j))))

(* Is the given pixel within the image ? *)
fun inBounds (img : image) ((x,y) : int * int) : bool =
    x >= 0 andalso y >= 0 andalso y < Array.length img
    andalso x < Array.length (Array.sub(img, y))

(* Return an option containing the neighbors we should explore next, if any.*)
fun neighbors (img : image) (c : color) ((x,y) : int * int) : (int * int) list option =
    if inBounds img (x,y) andalso Array.sub(Array.sub(img,y),x) <> c
    then SOME [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]
    else NONE

(* Update the given pixel of the image. *)
fun setPixel (img : image) ((x,y) : int * int) (c : color) : unit =
    Array.update (Array.sub(img,y),x,c)

(* Recursive fill around the given point using the given color. *)
fun fill (img : image) (c : color) ((x,y) : int * int) : unit =
    case neighbors img c (x,y) of
        SOME xys => (setPixel img (x,y) c; List.app (fill img c) xys)
      | NONE => ()

val test = listToImage
[[0,0,1,1,0,1,0],
 [1,0,1,0,1,0,0],
 [1,0,0,0,0,0,1],
 [0,1,0,0,0,1,0],
 [1,0,0,0,0,0,1],
 [0,0,1,1,1,0,0],
 [0,1,0,0,0,1,0]]

(* Fill the image with black starting at the center. *)
val () = fill test Black (3,3)
