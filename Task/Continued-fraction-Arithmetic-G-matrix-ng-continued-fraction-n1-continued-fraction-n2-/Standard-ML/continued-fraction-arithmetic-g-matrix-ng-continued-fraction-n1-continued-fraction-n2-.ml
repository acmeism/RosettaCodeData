(*------------------------------------------------------------------*)

signature CONTINUED_FRACTION =
sig
  (* A termGenerator thunk generates terms, which a continuedFraction
     structure memoizes. *)
  type termGenerator = unit -> IntInf.int option
  type continuedFraction

  (* Create a continued fraction. *)
  val make : termGenerator -> continuedFraction

  (* Does the indexed term exist? *)
  val exists : continuedFraction * int -> bool

  (* Retrieving the indexed term. *)
  val sub : continuedFraction * int -> IntInf.int

  (* Using a continuedFraction as a termGenerator thunk. *)
  val toTermGenerator : continuedFraction -> termGenerator

  (* Producing a human-readable string. *)
  val toMaxTermsString : int -> continuedFraction -> string
  val defaultMaxTerms : int ref
  val toString : continuedFraction -> string

  (* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
  (* Creating some specific kinds of continued fractions: *)

  (* Representing an integer. *)
  val fromIntInf : IntInf.int -> continuedFraction
  val fromInt : int -> continuedFraction
  val i2cf : int -> continuedFraction (* Synonym for fromInt. *)

  (* With one term repeated forever. *)
  val withConstantIntInfTerm : IntInf.int -> continuedFraction
  val withConstantIntTerm : int -> continuedFraction

  (* Representing a rational number. *)
  val fromIntInfNumerDenom : IntInf.int * IntInf.int ->
                             continuedFraction
  val fromIntNumerDenom : int * int -> continuedFraction
  val r2cf : int * int ->
             continuedFraction  (* Synonym for fromIntNumerDenom. *)

  (* Representing arithmetic. (I have not bothered here to implement
     ng4, although one likely would wish to have ng4 as well.)  *)
  type ng8 = IntInf.int * IntInf.int * IntInf.int * IntInf.int *
             IntInf.int * IntInf.int * IntInf.int * IntInf.int
  val ng8_fromInt : int * int * int * int *
                    int * int * int * int -> ng8
  val ng8StoppingProcessingThreshold : IntInf.int ref
  val ng8InfinitizationThreshold : IntInf.int ref
  val apply_ng8 : ng8 ->
                  continuedFraction * continuedFraction ->
                  continuedFraction
  val + : continuedFraction * continuedFraction -> continuedFraction
  val - : continuedFraction * continuedFraction -> continuedFraction
  val * : continuedFraction * continuedFraction -> continuedFraction
  val / : continuedFraction * continuedFraction -> continuedFraction
  val ~ : continuedFraction -> continuedFraction
  val pow : continuedFraction * int -> continuedFraction

  (* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - *)
  (* Miscellanous continued fractions: *)

  val zero : continuedFraction
  val one : continuedFraction
  val two : continuedFraction
  val three : continuedFraction
  val four : continuedFraction

  val one_fourth : continuedFraction
  val one_third : continuedFraction
  val one_half : continuedFraction
  val two_thirds : continuedFraction
  val three_fourths : continuedFraction

  val goldenRatio : continuedFraction
  val silverRatio : continuedFraction
  val sqrt2 : continuedFraction
  val sqrt5 : continuedFraction

end

structure ContinuedFraction : CONTINUED_FRACTION =
struct

type termGenerator = unit -> IntInf.int option
type cfRecord = {
  terminated : bool,             (* Is the generator exhausted? *)
  memoCount  : int,              (* How many terms are memoized? *)
  memo       : IntInf.int array, (* Memoized terms. *)
  generate   : termGenerator     (* The source of terms. *)
}
type continuedFraction = cfRecord ref

fun make generator =
    ref {
      terminated = false,
      memoCount = 0,
      memo = Array.array (32, IntInf.fromInt 0),
      generate = generator
    }

fun resizeIfNecessary (cf : continuedFraction, i) =
    let
      val record = !cf
    in
      if #terminated record then
        ()
      else if i < Array.length (#memo record) then
        ()
      else
        let
          val newSize = 2 * (i + 1)
          val newMemo = Array.array (newSize, IntInf.fromInt 0)
          fun copyTerms i =
              if i = #memoCount record then
                ()
              else
                let
                  val term = Array.sub (#memo record, i)
                in
                  Array.update (newMemo, i, term);
                  copyTerms (i + 1)
                end
          val newRecord : cfRecord = {
            terminated = false,
            memoCount = #memoCount record,
            memo = newMemo,
            generate = #generate record
          }
        in
          copyTerms 0;
          cf := newRecord
        end
    end

fun updateTerms (cf : continuedFraction, i) =
    let
      val record = !cf
    in
      if #terminated record then
        ()
      else if i < #memoCount record then
        ()
      else
        case (#generate record) () of
            Option.NONE =>
            let
              val newRecord : cfRecord = {
                terminated = true,
                memoCount = #memoCount record,
                memo = #memo record,
                generate = #generate record
              }
            in
              cf := newRecord
            end
          | Option.SOME term =>
            let
              val () = Array.update (#memo record, #memoCount record,
                                     term)
              val newRecord : cfRecord = {
                terminated = false,
                memoCount = (#memoCount record) + 1,
                memo = #memo record,
                generate = #generate record
              }
            in
              cf := newRecord;
              updateTerms (cf, i)
            end
    end

fun exists (cf : continuedFraction, i) =
    (resizeIfNecessary (cf, i);
     updateTerms (cf, i);
     i < #memoCount (!cf))

fun sub (cf : continuedFraction, i) =
    let
      val record = !cf
    in
      if #memoCount record <= i then
        raise Domain
      else
        Array.sub (#memo record, i)
    end

fun toTermGenerator (cf : continuedFraction) =
    let
      val i : int ref = ref 0
    in
      fn () =>
         let
           val j = !i
         in
           if exists (cf, j) then
             (i := j + 1;
              Option.SOME (sub (cf, j)))
           else
             Option.NONE
         end
    end

fun toMaxTermsString maxTerms =
    if maxTerms < 1 then
      raise Domain
    else
      fn (cf : continuedFraction) =>
         let
           fun loop (i, accum) =
               if not (exists (cf, i)) then
                 accum ^ "]"
               else if i = maxTerms then
                 accum ^ ",...]"
               else
                 let
                   val separator =
                       if i = 0 then
                         ""
                       else if i = 1 then
                         ";"
                       else
                         ","
                   val termString = IntInf.toString (sub (cf, i))
                 in
                   loop (i + 1, accum ^ separator ^ termString)
                 end
         in
           loop (0, "[")
         end

val defaultMaxTerms : int ref = ref 20
val toString = toMaxTermsString (!defaultMaxTerms)

fun fromIntInf i =
    let
      val done : bool ref = ref false
    in
      make (fn () =>
               if !done then
                 Option.NONE
               else
                 (done := true;
                  Option.SOME i))
    end
fun fromInt i =
    fromIntInf (IntInf.fromInt i)
val i2cf = fromInt

fun withConstantIntInfTerm i =
    make (fn () => Option.SOME i)
fun withConstantIntTerm i =
    withConstantIntInfTerm (IntInf.fromInt i)

fun fromIntInfNumerDenom (n, d) =
    let
      val zero = IntInf.fromInt 0
      val state = ref (n, d)
    in
      make (fn () =>
               let
                 val (n, d) = !state
               in
                 if d = zero then
                   Option.NONE
                 else
                   let
                     val (q, r) = IntInf.divMod (n, d)
                   in
                     state := (d, r);
                     Option.SOME q
                   end
               end)
    end
fun fromIntNumerDenom (n, d) =
    fromIntInfNumerDenom (IntInf.fromInt n, IntInf.fromInt d)
val r2cf = fromIntNumerDenom

type ng8 = IntInf.int * IntInf.int * IntInf.int * IntInf.int *
           IntInf.int * IntInf.int * IntInf.int * IntInf.int

fun ng8_fromInt (a12, a1, a2, a, b12, b1, b2, b) =
    let
      val f = IntInf.fromInt
    in
      (f a12, f a1, f a2, f a, f b12, f b1, f b2, f b)
    end

val ng8StoppingProcessingThreshold =
    ref (IntInf.pow (IntInf.fromInt 2, 512))
val ng8InfinitizationThreshold =
    ref (IntInf.pow (IntInf.fromInt 2, 64))

fun tooBig term =
    abs (term) >= abs (!ng8StoppingProcessingThreshold)

fun anyTooBig (a, b, c, d, e, f, g, h) =
    tooBig (a) orelse tooBig (b) orelse
    tooBig (c) orelse tooBig (d) orelse
    tooBig (e) orelse tooBig (f) orelse
    tooBig (g) orelse tooBig (h)

fun infinitize term =
    if abs (term) >= abs (!ng8InfinitizationThreshold) then
      Option.NONE
    else
      Option.SOME term

fun noTermsSource () =
    Option.NONE

val equalZero =
    let
      val zero = IntInf.fromInt 0
    in
      fn b => (b = zero)
    end

val divide =
    let
      val zero = IntInf.fromInt 0
    in
      fn (a, b) =>
         if equalZero b then
           (zero, zero)
         else
           IntInf.divMod (a, b)
    end

fun apply_ng8 ng =
    fn (x, y) =>
       let
         val ng = ref ng
         and xsource = ref (toTermGenerator x)
         and ysource = ref (toTermGenerator y)

         fun all_b_areZero () =
             let
               val (_, _, _, _, b12, b1, b2, b) = !ng
             in
               equalZero b andalso
               equalZero b2 andalso
               equalZero b1 andalso
               equalZero b12
             end

         fun allFourEqual (a, b, c, d) =
             a = b andalso a = c andalso a = d

         fun absorb_x_term () =
             let
               val (a12, a1, a2, a, b12, b1, b2, b) = !ng
             in
               case (!xsource) () of
                   Option.SOME term =>
                   let
                     val new_ng = (a2 + (a12 * term),
                                   a + (a1 * term), a12, a1,
                                   b2 + (b12 * term),
                                   b + (b1 * term), b12, b1)
                   in
                     if anyTooBig new_ng then
                       (* Pretend all further x terms are infinite. *)
                       (ng := (a12, a1, a12, a1, b12, b1, b12, b1);
                        xsource := noTermsSource)
                     else
                       ng := new_ng
                   end
                 | Option.NONE =>
                   ng := (a12, a1, a12, a1, b12, b1, b12, b1)
             end

         fun absorb_y_term () =
             let
               val (a12, a1, a2, a, b12, b1, b2, b) = !ng
             in
               case (!ysource) () of
                   Option.SOME term =>
                   let
                     val new_ng = (a1 + (a12 * term), a12,
                                   a + (a2 * term), a2,
                                   b1 + (b12 * term), b12,
                                   b + (b2 * term), b2)
                   in
                     if anyTooBig new_ng then
                       (* Pretend all further y terms are infinite. *)
                       (ng := (a12, a12, a2, a2, b12, b12, b2, b2);
                        ysource := noTermsSource)
                     else
                       ng := new_ng
                   end
                 | Option.NONE =>
                   ng := (a12, a12, a2, a2, b12, b12, b2, b2)
             end

         fun loop () =
             (* Although my Scheme version of this program used mutual
                tail recursion, here there is only single tail
                recursion.  The difference is that in SML we cannot
                rely on properness of mutual tail calls, the way we
                can in standard Scheme. *)
             if all_b_areZero () then
               Option.NONE    (* There are no more terms to output. *)
             else
               let
                 val (_, _, _, _, b12, b1, b2, b) = !ng
               in
                 if equalZero b andalso equalZero b2 then
                   (absorb_x_term (); loop ())
                 else if equalZero b orelse equalZero b2 then
                   (absorb_y_term (); loop ())
                 else if equalZero b1 then
                   (absorb_x_term (); loop ())
                 else
                   let
                     val (a12, a1, a2, a, _, _, _, _) = !ng
                     val (q12, r12) = divide (a12, b12)
                     and (q1, r1) = divide (a1, b1)
                     and (q2, r2) = divide (a2, b2)
                     and (q, r) = divide (a, b)
                   in
                     if b12 <> 0 andalso
                        allFourEqual (q12, q1, q2, q) then
                       (ng := (b12, b1, b2, b, r12, r1, r2, r);
                        (* Return a term--or, if a magnitude threshold
                           is reached, return no more terms . *)
                        infinitize q)
                     else
                       let
                         (* Put a1, a2, and a over a common
                            denominator and compare some
                            magnitudes. *)
                         val n1 = a1 * b2 * b
                         and n2 = a2 * b1 * b
                         and n = a * b1 * b2
                       in
                         if abs (n1 - n) > abs (n2 - n) then
                           (absorb_x_term (); loop ())
                         else
                           (absorb_y_term (); loop ())
                       end
                   end
               end
       in
         make (fn () => loop ())
       end

val op+ = apply_ng8 (ng8_fromInt (0, 1, 1, 0, 0, 0, 0, 1))
val op- = apply_ng8 (ng8_fromInt (0, 1, ~1, 0, 0, 0, 0, 1))
val op* = apply_ng8 (ng8_fromInt (1, 0, 0, 0, 0, 0, 0, 1))
val op/ = apply_ng8 (ng8_fromInt (0, 1, 0, 0, 0, 0, 1, 0))

val op~ =
    let
      val neg = apply_ng8 (ng8_fromInt (0, 0, ~1, 0, 0, 0, 0, 1))
    in
      fn (x) => neg (x, x)
    end

val pow =
    let
      val one = i2cf 1
      val reciprocal =
          fn (x) =>
             apply_ng8 (ng8_fromInt (0, 0, 0, 1, 0, 1, 0, 0))
                       (x, x)
    in
      fn (cf, i) =>
         let
           fun loop (x, n, accum) =
               if 1 < n then
                 let
                   val nhalf = n div 2
                   and xsquare = x * x
                 in
                   if Int.+ (nhalf, nhalf) <> n then
                     loop (xsquare, nhalf, accum * x)
                   else
                     loop (xsquare, nhalf, accum)
                 end
               else if n = 1 then
                 accum * x
               else
                 accum
         in
           if 0 <= i then
             loop (cf, i, one)
           else
             reciprocal (loop (cf, Int.~ i, one))
         end
    end

val zero = i2cf 0
val one = i2cf 1
val two = i2cf 2
val three = i2cf 3
val four = i2cf 4

val one_fourth = r2cf (1, 4)
val one_third = r2cf (1, 3)
val one_half = r2cf (1, 2)
val two_thirds = r2cf (2, 3)
val three_fourths = r2cf (3, 4)

val goldenRatio = withConstantIntTerm 1
val silverRatio = withConstantIntTerm 2
val sqrt2 = silverRatio - one
val sqrt5 = (two * goldenRatio) - one

end

(*------------------------------------------------------------------*)

fun makePad n =
    String.implode (List.tabulate (n, fn i => #" "))

fun show (expression : string,
          cf         : ContinuedFraction.continuedFraction,
          note       : string) =
    let
      val cfString = ContinuedFraction.toString cf

      val exprSz = size expression
      and cfSz = size cfString
      and noteSz = size note

      val exprPadSize = Int.max (19 - exprSz, 0)
      and cfPadSize = if noteSz = 0 then 0 else Int.max (48 - cfSz, 0)

      val exprPad = makePad exprPadSize
      and cfPad = makePad cfPadSize
    in
      print exprPad;
      print expression;
      print " =>  ";
      print cfString;
      print cfPad;
      print note;
      print "\n"
    end;

let
  open ContinuedFraction
in
  show ("golden ratio", goldenRatio, "(1 + sqrt(5))/2");
  show ("silver ratio", silverRatio, "(1 + sqrt(2))");
  show ("sqrt2", sqrt2, "");
  show ("sqrt5", sqrt5, "");

  show ("1/4", one_fourth, "");
  show ("1/3", one_third, "");
  show ("1/2", one_half, "");
  show ("2/3", two_thirds, "");
  show ("3/4", three_fourths, "");

  show ("13/11", r2cf (13, 11), "");
  show ("22/7", r2cf (22, 7), "approximately pi");

  show ("0", zero, "");
  show ("1", one, "");
  show ("2", two, "");
  show ("3", three, "");
  show ("4", four, "");
  show ("4 + 3", four + three, "");
  show ("4 - 3", four - three, "");
  show ("4 * 3", four * three, "");
  show ("4 / 3", four / three, "");
  show ("4 ** 3", pow (four, 3), "");
  show ("4 ** (-3)", pow (four, ~3), "");
  show ("negative 4", ~four, "");

  show ("(1 + 1/sqrt(2))/2",
        (one + (one / sqrt2)) / two, "method 1");
  show ("(1 + 1/sqrt(2))/2",
        silverRatio * pow (sqrt2, ~3), "method 2");
  show ("(1 + 1/sqrt(2))/2",
        (pow (silverRatio, 2) + one) / (four * two), "method 3");

  show ("sqrt2 + sqrt2", sqrt2 + sqrt2, "");
  show ("sqrt2 - sqrt2", sqrt2 - sqrt2, "");
  show ("sqrt2 * sqrt2", sqrt2 * sqrt2, "");
  show ("sqrt2 / sqrt2", sqrt2 / sqrt2, "");

  ()
end;

(*------------------------------------------------------------------*)
(* local variables: *)
(* mode: sml *)
(* sml-indent-level: 2 *)
(* sml-indent-args: 2 *)
(* end: *)
