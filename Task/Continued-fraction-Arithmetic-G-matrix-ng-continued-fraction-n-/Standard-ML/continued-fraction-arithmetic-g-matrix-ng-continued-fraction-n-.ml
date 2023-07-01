(*------------------------------------------------------------------*)

signature CF =
sig
  type gen_t = unit -> int Option.option
  type cf_t

  val make : gen_t -> cf_t
  val sub : cf_t * int -> int Option.option
  val toThunk : cf_t -> gen_t   (* To use a cf_t as a generator. *)
  val toStringWithMaxTerms : cf_t * int -> String.string
  val toString : cf_t -> String.string
end

structure Cf : CF =
struct

type gen_t = unit -> int Option.option
type record_t =
     {
       terminated : bool,
       m : int,
       memo : int Array.array,
       gen : gen_t
     }
type cf_t = record_t ref

fun make gen =
    ref
      {
        terminated = false,
        m = 0,
        memo = Array.array (8, 0),
        gen = gen
      }

fun sub (cf, i) =
    let
      fun getMoreTerms (record : record_t, needed : int) =
          let
            fun loop j =
                if j = needed then
                  {
                    terminated = false,
                    m = needed,
                    memo = #memo record,
                    gen = #gen record
                  }
                else
                  (case (#gen record) () of
                       Option.NONE =>
                       {
                         terminated = true,
                         m = i,
                         memo = #memo record,
                         gen = #gen record
                       }
                     | Option.SOME term =>
                       (Array.update (#memo record, i, term);
                        loop (j + 1)))
          in
            loop (#m record)
          end

      fun updateTerms (record : record_t, needed : int) =
          if #terminated record then
            record
          else if needed <= #m record then
            record
          else if needed <= Array.length (#memo record) then
            getMoreTerms (record, needed)
          else
            (* Provide more storage for memoized terms. *)
            let
              val n1 = needed + needed
              val memo1 = Array.array (n1, 0)
              fun copy_over i =
                  if i = #m record then
                    ()
                  else
                    (Array.update (memo1, i,
                                   Array.sub (#memo record, i));
                     copy_over (i + 1))
              val () = copy_over 0
              val record =
                  {
                    terminated = false,
                    m = #m record,
                    memo = memo1,
                    gen = #gen record
                  }
            in
              getMoreTerms (record, needed)
            end

      val record = updateTerms (!cf, i + 1)
    in
      cf := record;
      if i < #m record then
        Option.SOME (Array.sub (#memo record, i))
      else
        Option.NONE
    end

fun toThunk cf =
    let
      val index = ref 0
    in
      fn () =>
         let
           val i = !index
         in
           index := i + 1;
           sub (cf, i)
         end
    end

fun toStringWithMaxTerms (cf, maxTerms : int) =
    let
      fun loop (i, sep, accum) =
          if i = maxTerms then
            accum ^ ",...]"
          else
            (case sub (cf, i) of
                 Option.NONE => accum ^ "]"
               | Option.SOME term =>
                 let
                   val sepStr =
                       if i = 0 then
                         ""
                       else if i = 1 then
                         ";"
                       else
                         ","
                   val sep = Int.min (sep + 1, 2)
                   val termStr = Int.toString term
                 in
                   loop (i + 1, sep, accum ^ sepStr ^ termStr)
                 end)
    in
      loop (0, 0, "[")
    end

fun toString cf =
    toStringWithMaxTerms (cf, 20)

end (* structure Cf : CF *)

(*------------------------------------------------------------------*)
(* A continued fraction for the square root of two. *)

val cf_sqrt2 =
    Cf.make
      let
        val nextTerm = ref 1
      in
        fn () =>
           let
             val term = !nextTerm
           in
             nextTerm := 2;
             Option.SOME term
           end
      end ;

(*------------------------------------------------------------------*)
(* Make a continued fraction for a rational number. *)

fun cfRational (n : int, d : int) =
    Cf.make
      let
        val ratnum = ref (n, d)
      in
        fn () =>
           let
             val (n, d) = !ratnum
           in
             if d = 0 then
               Option.NONE
             else
               let
                 (* This is floor division. For truncation towards
                    zero, use "quot" and "rem". *)
                 val q = n div d
                 and r = n mod d
               in
                 ratnum := (d, r);
                 Option.SOME q
               end
           end
      end ;

(*------------------------------------------------------------------*)
(* Make a continued fraction that is the application of a homographic
   function to another continued fraction. *)

fun cfHFunc (a1 : int, a : int, b1 : int, b : int)
            (other_cf : Cf.cf_t) =
  let
    val gen = Cf.toThunk other_cf
    val state = ref (a1, a, b1, b, gen)
    fun hgen () =
        let
          fun loop () =
              let
                val (a1, a, b1, b, gen) = !state
                fun absorb_term () =
                    case gen () of
                        Option.NONE =>
                        state := (a1, a1, b1, b1, gen)
                      | Option.SOME term =>
                        state := (a + (a1 * term), a1,
                                  b + (b1 * term), b1,
                                  gen)
              in
                if b1 = 0 andalso b = 0 then
                  Option.NONE
                else if b1 <> 0 andalso b <> 0 then
                  let
                    (* This is floor division. For truncation towards
                       zero, use "quot" instead. *)
                    val q1 = a1 div b1
                    and q = a div b
                  in
                    if q1 = q then
                      (state := (b1, b, a1 - (b1 * q), a - (b * q),
                                 gen);
                       Option.SOME q)
                    else
                      (absorb_term ();
                       loop ())
                  end
                else
                  (absorb_term ();
                   loop ())
              end
        in
          loop ()
        end
  in
    Cf.make hgen
  end ;

(* Some unary operations. *)
val add_one_half = cfHFunc (2, 1, 0, 2) ;
val add_one = cfHFunc (1, 1, 0, 1) ;
val div_by_two = cfHFunc (1, 0, 0, 2) ;
val div_by_four = cfHFunc (1, 0, 0, 4) ;
val one_div_cf = cfHFunc (0, 1, 1, 0) ;

(*------------------------------------------------------------------*)

fun show (expr, cf) =
    (print expr;
     print " => ";
     print (Cf.toString cf);
     print "\n") ;

fun main () =
    let
      val cf_13_11 = cfRational (13, 11)
      val cf_22_7 = cfRational (22, 7)
      val cf_1_div_sqrt2 = one_div_cf cf_sqrt2
    in
      show ("13/11", cf_13_11);
      show ("22/7", cf_22_7);
      show ("sqrt(2)", cf_sqrt2);
      show ("13/11 + 1/2", add_one_half cf_13_11);
      show ("22/7 + 1/2", add_one_half cf_22_7);
      show ("(22/7)/4", div_by_four cf_22_7);
      show ("1/sqrt(2)", cf_1_div_sqrt2);
      show ("(2 + sqrt(2))/4", cfHFunc (1, 2, 0, 4) cf_sqrt2);

      (* Demonstrate a chain of operations. *)
      show ("(1 + 1/sqrt(2))/2",
            div_by_two (add_one cf_1_div_sqrt2));

      (* Demonstrate a slightly longer chain of operations. *)
      show ("((sqrt(2)/2) + 1)/2",
            div_by_two (add_one (div_by_two cf_sqrt2)))
    end ;

(*------------------------------------------------------------------*)

(* Comment out the following line, if you are using polyc, but not if
   you are using mlton or "poly --script". If you are using SML/NJ, I
   do not know what to do. :) *)
main () ;

(*------------------------------------------------------------------*)
(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
