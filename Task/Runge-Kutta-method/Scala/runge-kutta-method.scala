object Main extends App {
   val f = (t: Double, y: Double) => t * Math.sqrt(y) // Runge-Kutta solution
   val g = (t: Double) => Math.pow(t * t + 4, 2) / 16 // Exact solution
   new Calculator(f, Some(g)).compute(100, 0, .1, 1)
}

class Calculator(f: (Double, Double) => Double, g: Option[Double => Double] = None) {
   def compute(counter: Int, tn: Double, dt: Double, yn: Double): Unit = {
      if (counter % 10 == 0) {
         val c = (x: Double => Double) => (t: Double) => {
            val err = Math.abs(x(t) - yn)
            f" Error: $err%7.5e"
         }
         val s = g.map(c(_)).getOrElse((x: Double) => "") // If we don't have exact solution, just print nothing
         println(f"y($tn%4.1f) = $yn%12.8f${s(tn)}") // Else, print Error estimation here
      }
      if (counter > 0) {
         val dy1 = dt * f(tn, yn)
         val dy2 = dt * f(tn + dt / 2, yn + dy1 / 2)
         val dy3 = dt * f(tn + dt / 2, yn + dy2 / 2)
         val dy4 = dt * f(tn + dt, yn + dy3)
         val y = yn + (dy1 + 2 * dy2 + 2 * dy3 + dy4) / 6
         val t = tn + dt
         compute(counter - 1, t, dt, y)
      }
   }
}
