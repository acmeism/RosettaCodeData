object MultiDimensionalArray extends App {

  // Create a regular 4 dimensional array and initialize successive elements to the values 1 to 120
  val a4 = Array.fill[Int](5, 4, 3, 2) { m += 1; m }
  var m = 0

  println("First element = " + a4(0)(0)(0)(0)) // access and print value of first element
  println("Last element  = " + a4.last.last.last.last)
  a4(0)(0)(0)(0) = 121 // change value of first element

  println(a4.flatten.flatten.flatten.mkString(", "))

}
