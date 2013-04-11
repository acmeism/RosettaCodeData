fun integrate (f, a, b, steps, meth) = let
  val h = (b - a) / real steps
  fun helper (i, s) =
    if i >= steps then s
    else helper (i+1, s + meth (f, a + h * real i, h))
in
  h * helper (0, 0.0)
end

fun leftRect  (f, x, _) = f x
fun midRect   (f, x, h) = f (x + h / 2.0)
fun rightRect (f, x, h) = f (x + h)
fun trapezium (f, x, h) = (f x + f (x + h)) / 2.0
fun simpson   (f, x, h) = (f x + 4.0 * f (x + h / 2.0) + f (x + h)) / 6.0

fun square x = x * x


val rl = integrate (square, 0.0, 1.0, 10, left_rect )
val rm = integrate (square, 0.0, 1.0, 10, mid_rect  )
val rr = integrate (square, 0.0, 1.0, 10, right_rect)
val t  = integrate (square, 0.0, 1.0, 10, trapezium )
val s  = integrate (square, 0.0, 1.0, 10, simpson   )
