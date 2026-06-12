#!/bin/sh
exec scala "$0" "$@"
!#
  def hailstone(n: Int): Stream[Int] =
       n #:: (if (n == 1) Stream.empty else hailstone(if (n % 2 == 0) n / 2 else n * 3 + 1))

  val nr = argv.headOption.map(_.toInt).getOrElse(27)
  val collatz = hailstone(nr)
  println(s"Use the routine to show that the hailstone sequence for the number: $nr.")
  println(collatz.toList)
  println(s"It has ${collatz.length} elements.")
