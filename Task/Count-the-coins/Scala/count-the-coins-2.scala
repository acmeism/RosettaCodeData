def count(target: Int, coins: List[Int]): Int = {
  if (target == 0) 1
  else if (coins.isEmpty || target < 0) 0
  else count(target, coins.tail) + count(target - coins.head, coins)
}


count(100, List(25, 10, 5, 1))
