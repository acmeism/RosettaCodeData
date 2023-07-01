val depts = {
  (1 to 7).permutations.map{ n => (n(0),n(1),n(2)) }.toList.distinct  // All permutations of possible department numbers
  .filter{ n => n._1 % 2 == 0 }                                       // Keep only even numbers favored by Police Chief
  .filter{ n => n._1 + n._2 + n._3 == 12 }                            // Keep only numbers that add to 12
}

{
println( "(Police, Sanitation, Fire)")
println( depts.mkString("\n") )
}
