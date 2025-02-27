structure SplitMix64 =
struct
  structure W64 = Word64

  val randmax = (0wxFFFFFFFFFFFFFFFF : W64.word)

  (* if NONE is passed, seed using the current time *)
  fun init NONE =
        W64.fromLargeInt (Time.toNanoseconds (Time.now ()))
    | init (SOME x) = x
  (* takes the state and returns a tuple of the
   * new state and the random number *)
  fun next instate =
    let
      val newstate = instate + 0wx9e3779b97f4a7c15
      val z1 = W64.xorb (newstate, W64.>> (newstate, 0w30))
      val z2 = z1 * 0wxbf58476d1ce4e5b9
      val z3 = W64.xorb (z2, W64.>> (z2, 0w27))
      val z4 = z3 * 0wx94d049bb133111eb
    in
      (newstate, W64.xorb (z4, W64.>> (z4, 0w31)))
    end
  (* need to use LargeInt to fit the values *)
  fun nextInt instate =
    let
      val (newstate, res) = next instate
      val intres = W64.toLargeInt res
    in
      (newstate, intres)
    end
  fun nextReal instate =
    let
      val (newstate, res) = next instate
      val realres = Real.fromLargeInt (W64.toLargeInt (res))
    in
      (* divide by 2^64 *)
      (newstate, realres * (1.0 / 18446744073709551616.0))
    end
  (* gets the next number in the range min <= x < max without bias *)
  fun nextRange instate (min, max) =
    let
      val minword = W64.fromInt min
      val maxword = W64.fromInt max
      val maxfromzero = maxword - minword
      val ignored_range = randmax - randmax mod maxword
      val (newstate, res) = next instate
    in
      if res >= ignored_range then nextRange newstate (min, max)
      else (newstate, (res mod maxword) + minword)
    end
end

(* produce a list of n random ints using given seed *)
fun getRandIntList (seed, n) =
  let
    val init = SplitMix64.init seed
    fun aux (0, acc, _) = rev acc
      | aux (n, acc, state) =
          let val (newstate, res) = SplitMix64.nextInt state
          in aux (n - 1, res :: acc, newstate)
          end
  in
    aux (n, [], init)
  end

fun testNextReal (seed, n) =
  let
    val hist = Array.array (n, 0)
    val nreal = Real.fromInt n
    fun loopFn 0 _ = ()
      | loopFn n state =
          let
            val (newstate, res) = SplitMix64.nextReal state
            val idx = Real.floor (res * nreal)
            val old_count = Array.sub (hist, idx)
          in
            (Array.update (hist, idx, old_count + 1); loopFn (n - 1) newstate)
          end
    val () = loopFn 100000 (SplitMix64.init seed)
  in
    Array.foldri
      (fn (i, x, l) =>
         (String.concat [Int.toString i, ": ", Int.toString x]) :: l) [] hist
  end

fun main () =
  let
    val five_ints = getRandIntList (0w1234567, 5)
    val () = app (print o (fn s => s ^ "\n") o LargeInt.toString) five_ints
    val () = print "\n"
    val hist_list = testNextReal (0w987654321, 5)
    val () = print (String.concatWith ", " hist_list)
    val () = print "\n"
  in
    ()
  end

val () = main ()
