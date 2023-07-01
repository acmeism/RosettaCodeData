object IdiomaticallyDetermineLowercaseUppercase extends App {

  println("Upper case: "
    + (0 to 0x10FFFF).map(_.toChar).filter(_.isUpper).take(72).mkString + "...")

  println("Lower case: "
    + (0 to 0x10FFFF).map(_.toChar).filter(_.isLower).take(72).mkString + "...")

}
