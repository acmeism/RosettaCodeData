structure SplitMix64 =
struct
  structure W64 = Word64

  val randmax = (0wxFFFFFFFFFFFFFFFF : W64.word)

  (* if NONE is passed, seed using the current time *)
  fun init NONE =
        W64.fromLargeInt (Time.toNanoseconds (Time.now ()))
    | init (SOME x) = x

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

fun getRandBytes n =
  let
    val prng = ref (SplitMix64.init NONE)
    fun nextRand _ =
      let val (prng', res) = SplitMix64.nextRange (!prng) (0, 255)
      in prng := prng'; Word8.fromInt (Word64.toInt res)
      end
  in
    Word8Vector.tabulate (n, nextRand)
  end

fun binPrint ostrm s =
  BinIO.output (ostrm, Byte.stringToBytes s)

fun printPPMHeader ostrm (width, height) =
  let
    val bprint = binPrint ostrm
  in
    ( bprint "P6\n"
    ; bprint (Int.toString width)
    ; bprint " "
    ; bprint (Int.toString height)
    ; bprint "\n255\n"
    )
  end

fun printRandomPPM ostrm (width, height) =
  let
    (* multiply by three for R G B *)
    val bytes = getRandBytes width * height * 3
  in
    (printPPMHeader ostrm (width, height); BinIO.output (ostrm, bytes))
  end

fun showUsage () =
  ( print "Usage: "
  ; print (CommandLine.name ())
  ; print " <output_name> [width] [height]\n"
  ; print "  width and height default to 512 if not specified\n"
  ; OS.Process.exit OS.Process.failure
  )

fun parseArgs [] = showUsage ()
  | parseArgs [outname] = {outname = outname, width = 512, height = 512}
  | parseArgs [outname, width, height] =
      { outname = outname
      , width = valOf (Int.fromString width)
      , height = valOf (Int.fromString height)
      }
  | parseArgs _ = showUsage ()

fun main () =
  let
    val {outname, width, height} = parseArgs (CommandLine.arguments ())
    val ostrm = BinIO.openOut outname
  in
    printRandomPPM ostrm (width, height) before BinIO.closeOut ostrm
  end

val () = main ()
