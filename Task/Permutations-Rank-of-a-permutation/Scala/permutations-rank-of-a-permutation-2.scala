def check(n: Int, x: BigInt): Boolean = {
  val perm = indexToPermutation(n, x)
  val xOut = permutationToIndex(perm)
  println(s"$x -> $perm -> $xOut")
  xOut == x
}

if ((0 to 5).map(BigInt.apply).forall(check(3, _))) {
  println("Success!")
} else {
  println("Failed")
}
