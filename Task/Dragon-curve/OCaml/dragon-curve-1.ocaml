(* This constant does not seem to be defined anywhere in the standard modules *)
let pi = acos (-1.0);

(*
** CLASS dragon_curve_computer:
** ----------------------------
** Computes the coordinates for the line drawing the curve.
** - initial_x initial_y: coordinates for starting point for curve
** - total_length: total length for the curve
** - total_splits: total number of splits to perform
*)
class dragon_curve_computer initial_x initial_y total_length total_splits =
  object(self)
    val mutable current_x = (float_of_int initial_x)  (* current x coordinate in curve *)
    val mutable current_y = (float_of_int initial_y)  (* current y coordinate in curve *)
    val mutable current_angle = 0.0                   (* current angle *)

    (*
    ** METHOD compute_coords:
    ** ----------------------
    ** Actually computes the coordinates in the line for the curve
    ** - length: length for current iteration
    ** - nb_splits: number of splits to perform for current iteration
    ** - direction: direction for current line (-1.0 or 1.0)
    ** Returns: the list of coordinates for the line in this iteration
    *)
    method compute_coords length nb_splits direction =
      (* If all splits have been done *)
      if nb_splits = 0
      then
        begin
          (* Draw line segment, updating current coordinates *)
          current_x <- current_x +. length *. cos current_angle;
          current_y <- current_y +. length *. sin current_angle;
          [(int_of_float current_x, int_of_float current_y)]
        end
      (* If there are still splits to perform *)
      else
        begin
          (* Compute length for next iteration *)
          let sub_length = length /. sqrt 2.0 in
          (* Turn 45 degrees to left or right depending on current direction and draw part
             of curve in this direction *)
          current_angle <- current_angle +. direction *. pi /. 4.0;
          let coords1 = self#compute_coords sub_length (nb_splits - 1) 1.0 in
          (* Turn 90 degrees in the other direction and draw part of curve in that direction *)
          current_angle <- current_angle -. direction *. pi /. 2.0;
          let coords2 = self#compute_coords sub_length (nb_splits - 1) (-1.0) in
          (* Turn back 45 degrees to set head in the initial direction again *)
          current_angle <- current_angle +. direction *. pi /. 4.0;
          (* Concatenate both sub-curves to get the full curve for this iteration *)
          coords1 @ coords2
        end

    (*
    ** METHOD get_coords:
    ** ------------------
    ** Returns the coordinates for the curve with the parameters set in the object initializer
    *)
    method get_coords = self#compute_coords total_length total_splits 1.0
  end;;


(*
** MAIN PROGRAM:
** =============
*)
let () =
  (* Curve is displayed in a Tk canvas *)
  let top=Tk.openTk() in
  let c = Canvas.create ~width:400 ~height:400 top in
  Tk.pack [c];
  (* Create instance computing the curve coordinates *)
  let dcc = new dragon_curve_computer 100 200 200.0 16 in
  (* Create line with these coordinates in canvas *)
  ignore (Canvas.create_line ~xys: dcc#get_coords c);
  Tk.mainLoop ();
;;
