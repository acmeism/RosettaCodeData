	def loop(iter: Int, cond: (Int) => Boolean, accu: List[Int]): List[Int] = {
	  val succ = iter + 1
	  val temp = accu :+ succ
	  if (cond(succ)) loop(succ, cond, temp) else temp
	}
	println(loop(0, (_ % 6 != 0), Nil))
