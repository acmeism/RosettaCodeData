module CF =                     (* A continued fraction. *)
  struct
    type record_t =
      {
        terminated : bool;   (* Are there no more terms to memoize? *)
        m : int;             (* The number of memoized terms. *)
        memo : int Array.t;  (* Storage for the memoized terms. *)
        gen : unit -> int option; (* A generator of new terms. *)
      }

    type t = record_t ref

    let make gen =
      ref { terminated = false;
            m = 0;
            memo = Array.make (8) 0;
            gen = gen }

    let get cf i =
      let get_more_terms record needed =
        let rec loop j =
          if j = needed then
            { record with terminated = false; m = needed }
          else
            match record.gen () with
            | None -> { record with terminated = true; m = i }
            | Some term ->
               begin
                 record.memo.(i) <- term;
                 loop (j + 1)
               end
        in
        loop record.m
      in
      let update record needed =
        if record.terminated then
          record
        else if needed <= record.m then
          record
        else if needed <= Array.length record.memo then
          get_more_terms record needed
        else
          (* Provide twice the room that might be needed. *)
          let n1 = needed + needed in
          let memo1 = Array.make (n1) 0 in
          let record =
            begin
              for j = 0 to record.m - 1 do
                memo1.(j) <- record.memo.(j)
              done;
              { record with memo = memo1 }
            end
          in
          get_more_terms record needed
      in
      let record = update !cf (i + 1) in
      begin
        cf := record;
        if i < record.m then
          Some record.memo.(i)
        else
          None
      end

    let to_string ?max_terms:(max_terms = 20) cf =
      let rec loop i sep accum =
        if i = max_terms then
          accum ^ ",...]"
        else
          match get cf i with
          | None -> accum ^ "]"
          | Some term ->
             let sep_str =
               match sep with
               | 0 -> ""
               | 1 -> ";"
               | _ -> ","
             in
             let sep = min (sep + 1) 2 in
             let term_str = string_of_int term in
             let accum = accum ^ sep_str ^ term_str in
             loop (i + 1) sep accum
      in
      loop 0 0 "["

    let to_thunk cf =     (* To use a CF.t as a generator of terms. *)
      let index = ref 0 in
      fun () -> let i = !index in
                begin
                  index := i + 1;
                  get cf i
                end
  end

let cf_sqrt2 =                 (* A continued fraction for sqrt(2). *)
  CF.make (let next_term = ref 1 in
           fun () -> let term = !next_term in
                     begin
                       next_term := 2;
                       Some term
                     end)

let cf_rational n d = (* Make a continued fraction for a rational
                         number. *)
  CF.make (let ratnum = ref (n, d) in
           fun () -> let (n, d) = !ratnum in
                     if d = 0 then
                       None
                     else
                       let q = n / d and r = n mod d in
                       begin
                         ratnum := (d, r);
                         Some q
                       end)

let cf_hfunc (a1, a, b1, b) other_cf =
  let gen = CF.to_thunk other_cf in
  let state = ref (a1, a, b1, b, gen) in
  let hgen () =
    let rec loop () =
      let (a1, a, b1, b, gen) = !state in
      let absorb_term () =
        match gen () with
        | None -> state := (a1, a1, b1, b1, gen)
        | Some term -> state := (a + (a1 * term), a1,
                                 b + (b1 * term), b1,
                                 gen)
      in
      if b1 = 0 && b = 0 then
        None
      else if b1 <> 0 && b <> 0 then
        let q1 = a1 / b1 and q = a / b in
        if q1 = q then
          begin
            state := (b1, b, a1 - (b1 * q), a - (b * q), gen);
            Some q
          end
        else
          begin
            absorb_term ();
            loop ()
          end
      else
        begin
          absorb_term ();
          loop ()
        end
    in
    loop ()
  in
  CF.make hgen

;;

let show expr cf =
  begin
    print_string expr;
    print_string " => ";
    print_string (CF.to_string cf);
    print_newline ()
  end ;;

let hf_cf_add_1_2 = (2, 1, 0, 2) ;;
let hf_cf_add_1 = (1, 1, 0, 1) ;;
let hf_cf_div_2 = (1, 0, 0, 2) ;;
let hf_cf_div_4 = (1, 0, 0, 4) ;;
let hf_1_div_cf = (0, 1, 1, 0) ;;

let cf_13_11 = cf_rational 13 11 ;;
let cf_22_7 = cf_rational 22 7 ;;
let cf_1_div_sqrt2 = cf_hfunc hf_1_div_cf cf_sqrt2 ;;

show "13/11" cf_13_11 ;;
show "22/7" cf_22_7 ;;
show "sqrt(2)" cf_sqrt2 ;;
show "13/11 + 1/2" (cf_hfunc hf_cf_add_1_2 cf_13_11) ;;
show "22/7 + 1/2" (cf_hfunc hf_cf_add_1_2 cf_22_7) ;;
show "(22/7)/4" (cf_hfunc hf_cf_div_4 cf_22_7) ;;
show "1/sqrt(2)" cf_1_div_sqrt2 ;;
show "(2 + sqrt(2))/4" (cf_hfunc (1, 2, 0, 4) cf_sqrt2) ;;

(* Demonstrate a chain of operations. *)
show "(1 + 1/sqrt(2))/2" (cf_1_div_sqrt2
                          |> cf_hfunc hf_cf_add_1
                          |> cf_hfunc hf_cf_div_2) ;;

(* Demonstrate a slightly longer chain of operations. *)
show "((sqrt(2)/2) + 1)/2" (cf_sqrt2
                            |> cf_hfunc hf_cf_div_2
                            |> cf_hfunc hf_cf_add_1
                            |> cf_hfunc hf_cf_div_2) ;;
