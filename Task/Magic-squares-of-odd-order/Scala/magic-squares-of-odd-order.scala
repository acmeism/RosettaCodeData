  def magicSquare( n:Int ) : Option[Array[Array[Int]]] = {
    require(n % 2 != 0, "n must be an odd number")

    val a = Array.ofDim[Int](n,n)

    // Make the horizontal by starting in the middle of the row and then taking a step back every n steps
    val ii = Iterator.continually(0 to n-1).flatten.drop(n/2).sliding(n,n-1).take(n*n*2).toList.flatten

    // Make the vertical component by moving up (subtracting 1) but every n-th step, step down (add 1)
    val jj = Iterator.continually(n-1 to 0 by -1).flatten.drop(n-1).sliding(n,n-2).take(n*n*2).toList.flatten

    // Combine the horizontal and vertical components to create the path
    val path = (ii zip jj) take (n*n)

    // Fill the array by following the path
    for( i<-1 to (n*n); p=path(i-1) ) { a(p._1)(p._2) = i }

    Some(a)
  }

  def output() :  Unit = {
    def printMagicSquare(n: Int): Unit = {

      val ms = magicSquare(n)
      val magicsum = (n * n + 1) / 2

      assert(
        if( ms.isDefined ) {
          val a = ms.get
          a.forall(_.sum == magicsum) &&
            a.transpose.forall(_.sum == magicsum) &&
            (for(i<-0 until n) yield { a(i)(i) }).sum == magicsum
        }
        else { false }
      )

      if( ms.isDefined ) {
        val a = ms.get
        for (y <- 0 to n * 2; x <- 0 until n) (x, y) match {
          case (0, 0) => print("╔════╤")
          case (i, 0) if i == n - 1 => print("════╗\n")
          case (i, 0) => print("════╤")

          case (0, j) if j % 2 != 0 => print("║ " + f"${ a(0)((j - 1) / 2) }%2d" + " │")
          case (i, j) if j % 2 != 0 && i == n - 1 => print(" " + f"${ a(i)((j - 1) / 2) }%2d" + " ║\n")
          case (i, j) if j % 2 != 0 => print(" " + f"${ a(i)((j - 1) / 2) }%2d" + " │")

          case (0, j) if j == (n * 2) => print("╚════╧")
          case (i, j) if j == (n * 2) && i == n - 1 => print("════╝\n")
          case (i, j) if j == (n * 2) => print("════╧")

          case (0, _) => print("╟────┼")
          case (i, _) if i == n - 1 => print("────╢\n")
          case (i, _) => print("────┼")
        }
      }
    }

    printMagicSquare(7)
  }
