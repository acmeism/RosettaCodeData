(* Compile and run with (for instance):

ocamlfind ocamlc -linkpkg -package zarith bivariate_continued_fraction_task.ml && ./a.out

 *)

module type CONTINUED_FRACTION =
  sig
    (* A term_generator thunk generates terms, which a t structure
       memoizes. *)
    type t
    type term_generator = unit -> Z.t option
    type ng8 = Z.t * Z.t * Z.t * Z.t * Z.t * Z.t * Z.t * Z.t

    (* Create a continued fraction. *)
    val make : term_generator -> t

    (* Does the indexed term exist? *)
    val exists : t -> int -> bool

    (* Retrieve the indexed term. *)
    val get : t -> int -> Z.t

    (* Use a t as a term_generator thunk. *)
    val to_term_generator : t -> term_generator

    (* Get a human-readable string. *)
    val default_max_terms : int ref
    val to_string : ?max_terms:int -> t -> string

    (* Create a continued fraction representing an integer. *)
    val of_bigint : Z.t -> t
    val of_int : int -> t

    (* Create a continued fraction representing a rational number. *)
    val of_bigrat : Q.t -> t
    val of_bigints : Z.t -> Z.t -> t
    val of_ints : int -> int -> t

    (* Create a continued fraction that has one term repeated
       forever. *)
    val constant_term_of_bigint : Z.t -> t
    val constant_term_of_int : int -> t

    (* Create a continued fraction by arithmetic. (I have not bothered
       here to implement ng4, although one likely would wish to have
       ng4 as well.)  *)
    val ng8_of_ints : (int * int * int * int
                       * int * int * int * int) -> ng8
    val ng8_stopping_processing_threshold : Z.t ref
    val ng8_infinitization_threshold : Z.t ref
    val apply_ng8 : ng8 -> t -> t -> t
    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t
    val ( * ) : t -> t -> t
    val ( / ) : t -> t -> t
    val ( ~- ) : t -> t
    val pow : t -> int -> t

    (* Miscellaneous continued fractions. *)
    val zero : t
    val one : t
    val two : t
    val three : t
    val four : t
    val one_fourth : t
    val one_third : t
    val one_half : t
    val two_thirds : t
    val three_fourths : t
    val golden_ratio : t
    val silver_ratio : t
    val sqrt2 : t
    val sqrt5 : t
  end

module Continued_fraction : CONTINUED_FRACTION =
  struct
    type term_generator = unit -> Z.t option
    type record_t =
      {
        terminated : bool;         (* Is the generator exhausted? *)
        memo_count : int;          (* How many terms are memoized? *)
        memo : Z.t Array.t;        (* Memoized terms. *)
        generate : term_generator; (* The source of terms. *)
      }
    type t = record_t ref
    type ng8 = Z.t * Z.t * Z.t * Z.t * Z.t * Z.t * Z.t * Z.t

    let make generator =
      ref { terminated = false;
            memo_count = 0;
            memo = Array.make 32 Z.zero;
            generate = generator }

    let resize_if_necessary (cf : t) i =
      let record = !cf in
      if record.terminated then
        ()
      else if i < Array.length record.memo then
        ()
      else
        let new_size = 2 * (i + 1) in
        let new_memo = Array.make new_size Z.zero in
        let rec copy_terms i =
          if i = record.memo_count then
            ()
          else
            let term = record.memo.(i) in
            new_memo.(i) <- term;
            copy_terms (i + 1)
        in
        let new_record = { record with memo = new_memo } in
        copy_terms 0;
        cf := new_record

    let rec update_terms (cf : t) i =
    let record = !cf in
    if record.terminated then
      ()
    else if i < record.memo_count then
      ()
    else
      match record.generate () with
      | None ->
         let new_record = { record with terminated = true} in
         cf := new_record
      | Some term ->
         let () = record.memo.(record.memo_count) <- term in
         let new_record = { record with memo_count =
                                          succ record.memo_count } in
         cf := new_record;
         update_terms cf i

    let exists (cf : t) i =
      resize_if_necessary cf i;
      update_terms cf i;
      i < (!cf).memo_count

    let get (cf : t) i =
      let record = !cf in
      if record.memo_count <= i then
        raise (Invalid_argument
                 "Continued_fraction.get:out_of_bounds")
      else
        record.memo.(i)

    let to_term_generator (cf : t) =
      let i : int ref = ref 0 in
      fun () -> let j = !i in
                if exists cf j then
                  begin
                    i := succ j;
                    Some (get cf j)
                  end
                else
                  None

    let default_max_terms = ref 20

    let to_string ?(max_terms = !default_max_terms) (cf : t) =
      if max_terms < 1 then
        raise (Invalid_argument
                 "Continued_fraction.to_string:max_terms_out_of_bounds")
      else
        let rec loop i accum =
          if not (exists cf i) then
            accum ^ "]"
          else if i = max_terms then
            accum ^ ",...]"
          else
            let separator = if i = 0 then
                              ""
                            else if i = 1 then
                              ";"
                            else
                              "," in
            let term_string = Z.to_string (get cf i) in
            loop (i + 1) (accum ^ separator ^ term_string)
        in
        loop 0 "["

    let of_bigint i =
      let finished = ref false in
      make (fun () -> (if !finished then
                         None
                       else
                         begin
                           finished := true;
                           Some i
                         end))
    let of_int i = of_bigint (Z.of_int i)
    let i2cf = of_int

    let constant_term_of_bigint i = make (fun () -> Some i)
    let constant_term_of_int i = constant_term_of_bigint (Z.of_int i)
    let constant_term_cf = constant_term_of_int

    let of_bigrat ratnum =
      let ratnum = ref ratnum in
      make (fun () -> (if Q.is_real !ratnum then
                         let (n, d) = (Q.num !ratnum,
                                       Q.den !ratnum) in
                         let (q, r) = Z.ediv_rem n d in
                         begin
                           ratnum := { num = d; den = r };
                           Some q
                         end
                       else
                         None))
    let of_bigints n d = of_bigrat { num = n; den = d }
    let of_ints n d = of_bigints (Z.of_int n) (Z.of_int d)

    let ng8_of_ints (a12, a1, a2, a, b12, b1, b2, b) =
      let f = Z.of_int in
      (f a12, f a1, f a2, f a, f b12, f b1, f b2, f b)

    let ng8_stopping_processing_threshold = ref Z.(one lsl 512)
    let ng8_infinitization_threshold = ref Z.(one lsl 64)

    let too_big term =
      Z.(abs (term) >= abs (!ng8_stopping_processing_threshold))

    let any_too_big (a, b, c, d, e, f, g, h) =
      too_big (a) || too_big (b)
      || too_big (c) || too_big (d)
      || too_big (e) || too_big (f)
      || too_big (g) || too_big (h)

    let infinitize term =
      if Z.(abs (term) >= abs (!ng8_infinitization_threshold)) then
        None
      else
        Some term

    let no_terms_source () = None

    let equal_zero number = (Z.sign number = 0)

    let divide a b =
      if equal_zero b then
        (Z.zero, Z.zero)
      else
        Z.ediv_rem a b

    let apply_ng8 (ng : ng8) =
      fun (x : t) (y : t) ->
      begin
       let ng = ref ng
       and xsource = ref (to_term_generator x)
       and ysource = ref (to_term_generator y) in

       let all_b_are_zero () =
         let (_, _, _, _, b12, b1, b2, b) = !ng in
         equal_zero b && equal_zero b2
         && equal_zero b1 && equal_zero b12
       in

       let all_four_equal (a, b, c, d) =
         a = b && a = c && a = d
       in

       let absorb_x_term () =
         let (a12, a1, a2, a, b12, b1, b2, b) = !ng in
         match (!xsource) () with
         | Some term ->
            let new_ng = Z.((a2 + (a12 * term),
                             a + (a1 * term), a12, a1,
                             b2 + (b12 * term),
                             b + (b1 * term), b12, b1)) in
            if any_too_big new_ng then
              (* Pretend all further x terms are infinite. *)
              begin
                ng := (a12, a1, a12, a1, b12, b1, b12, b1);
                xsource := no_terms_source
              end
            else
              ng := new_ng
         | None -> ng := (a12, a1, a12, a1, b12, b1, b12, b1)
       in

       let absorb_y_term () =
         let (a12, a1, a2, a, b12, b1, b2, b) = !ng in
         match (!ysource) () with
         | Some term ->
            let new_ng = Z.((a1 + (a12 * term), a12,
                             a + (a2 * term), a2,
                             b1 + (b12 * term), b12,
                             b + (b2 * term), b2)) in
            if any_too_big new_ng then
              (* Pretend all further y terms are infinite. *)
              begin
                ng := (a12, a12, a2, a2, b12, b12, b2, b2);
                ysource := no_terms_source
              end
            else
              ng := new_ng
         | None -> ng := (a12, a12, a2, a2, b12, b12, b2, b2)
       in

       let rec loop () =
         if all_b_are_zero () then
           None               (* There are no more terms to output. *)
         else
           let (_, _, _, _, b12, b1, b2, b) = !ng in
           if equal_zero b && equal_zero b2 then
             (absorb_x_term (); loop ())
           else if equal_zero b || equal_zero b2 then
             (absorb_y_term (); loop ())
           else if equal_zero b1 then
             (absorb_x_term (); loop ())
           else
             let (a12, a1, a2, a, _, _, _, _) = !ng in
             let (q12, r12) = divide a12 b12
             and (q1, r1) = divide a1 b1
             and (q2, r2) = divide a2 b2
             and (q, r) = divide a b in
             if Z.sign b12 <> 0 && all_four_equal (q12, q1, q2, q) then
               begin
                 ng := (b12, b1, b2, b, r12, r1, r2, r);
                 (* Return a term--or, if a magnitude threshold is
                    reached, return no more terms . *)
                 infinitize q
               end
             else
               begin
                 (* Put a1, a2, and a over a common denominator and
                    compare some magnitudes. *)
                 let n1 = Z.(a1 * b2 * b)
                 and n2 = Z.(a2 * b1 * b)
                 and n = Z.(a * b1 * b2) in
                 if Z.(abs (n1 - n) > abs (n2 - n)) then
                   (absorb_x_term (); loop ())
                 else
                   (absorb_y_term (); loop ())
               end
       in
       make (fun () -> loop ())
      end

    let ( + ) = apply_ng8 (ng8_of_ints (0, 1, 1, 0, 0, 0, 0, 1))
    let ( - ) = apply_ng8 (ng8_of_ints (0, 1, (-1), 0, 0, 0, 0, 1))
    let ( * ) = apply_ng8 (ng8_of_ints (1, 0, 0, 0, 0, 0, 0, 1))
    let ( / ) = apply_ng8 (ng8_of_ints (0, 1, 0, 0, 0, 0, 1, 0))

    let ( ~- ) =
      let neg = apply_ng8 (ng8_of_ints (0, 0, (-1), 0, 0, 0, 0, 1)) in
      fun x -> neg x x

    let pow =
      let one = of_int 1 in
      let reciprocal =
        apply_ng8 (ng8_of_ints (0, 0, 0, 1, 0, 1, 0, 0)) in
      let reciprocal x = reciprocal x x in
      fun cf i -> let rec loop (x : t) (n : int) (accum : t) =
                    if Int.(1 < n) then
                      let nhalf = Int.(div n 2)
                      and xsquare = x * x in
                      if Int.(add nhalf nhalf <> n) then
                        loop xsquare nhalf (accum * x)
                      else
                        loop xsquare nhalf accum
                    else if Int.(n = 1) then
                      (accum * x)
                    else
                      accum
                  in
                  if 0 <= i then
                    loop cf i one
                  else
                    reciprocal (loop cf Int.(neg i) one)

    let zero = of_int 0
    let one = of_int 1
    let two = of_int 2
    let three = of_int 3
    let four = of_int 4

    let one_fourth = of_ints 1 4
    let one_third = of_ints 1 3
    let one_half = of_ints 1 2
    let two_thirds = of_ints 2 3
    let three_fourths = of_ints 3 4

    let golden_ratio = constant_term_of_int 1
    let silver_ratio = constant_term_of_int 2
    let sqrt2 = silver_ratio - one
    let sqrt5 = (two * golden_ratio) - one

  end

module CF = Continued_fraction
;;

let i2cf = CF.of_int
and r2cf = CF.of_ints
and constant_term_cf = CF.constant_term_of_int
and cf2string = CF.to_string
;;

let make_pad n = String.make n ' '
;;

let show (expression, cf, note) =
  let cf_string = cf2string cf in

  let expr_sz = String.length expression
  and cf_sz = String.length cf_string
  and note_sz = String.length note in

  let expr_pad_sz = max (19 - expr_sz) 0
  and cf_pad_sz = if note_sz = 0 then 0 else max (48 - cf_sz) 0 in

  let expr_pad = make_pad expr_pad_sz
  and cf_pad = make_pad cf_pad_sz in
  print_string expr_pad;
  print_string expression;
  print_string " =>  ";
  print_string cf_string;
  print_string cf_pad;
  print_string note;
  print_endline ""
;;

show ("golden ratio", CF.golden_ratio, "(1 + sqrt(5))/2");
show ("silver ratio", CF.silver_ratio, "(1 + sqrt(2))");
show ("sqrt2", CF.sqrt2, "");
show ("sqrt5", CF.sqrt5, "");

show ("1/4", CF.one_fourth, "");
show ("1/3", CF.one_third, "");
show ("1/2", CF.one_half, "");
show ("2/3", CF.two_thirds, "");
show ("3/4", CF.three_fourths, "");

show ("13/11", r2cf 13 11, "");
show ("22/7", r2cf 22 7, "approximately pi");

show ("0", CF.zero, "");
show ("1", CF.one, "");
show ("2", CF.two, "");
show ("3", CF.three, "");
show ("4", CF.four, "");
show ("4 + 3", CF.(four + three), "");
show ("4 - 3", CF.(four - three), "");
show ("4 * 3", CF.(four * three), "");
show ("4 / 3", CF.(four / three), "");
show ("4 ** 3", CF.(pow four 3), "");
show ("4 ** (-3)", CF.(pow four (-3)), "");
show ("negative 4", CF.(-four), "");

CF.(show ("(1 + 1/sqrt(2))/2",
          (one + (one / sqrt2)) / two, "method 1"));
CF.(show ("(1 + 1/sqrt(2))/2",
          silver_ratio * pow sqrt2 (-3), "method 2"));
CF.(show ("(1 + 1/sqrt(2))/2",
          (pow silver_ratio 2 + one) / (four * two), "method 3"));

show ("sqrt2 + sqrt2", CF.(sqrt2 + sqrt2), "");
show ("sqrt2 - sqrt2", CF.(sqrt2 - sqrt2), "");
show ("sqrt2 * sqrt2", CF.(sqrt2 * sqrt2), "");
show ("sqrt2 / sqrt2", CF.(sqrt2 / sqrt2), "");
