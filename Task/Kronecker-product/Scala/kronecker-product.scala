 object KroneckerProduct
{
  /**Get the dimensions of the input matrix*/
  def getDimensions(matrix : Array[Array[Int]]) : (Int,Int) = {
    val dimensions = matrix.map(x => x.size)
    (dimensions.size, dimensions(0))
  }

  /**Compute the Kronecker product between 2 input matrixes and return the result as a matrix*/
  def kroneckerProduct(matrix1 : Array[Array[Int]], matrix2 : Array[Array[Int]]) : Array[Array[Int]] = {
    val (r1,c1) = getDimensions(matrix1)
    val (r2,c2) = getDimensions(matrix2)

    val res = Array.ofDim[Int](r1*r2, c1*c2)

    for(
      i <- 0 until r1;
      j <- 0 until c1;
      k <- 0 until r2;
      l <- 0 until c2
    ){
      res(r2 * i + k)(c2 * j + l) = matrix1(i)(j) * matrix2(k)(l)
    }

    res
  }

  def main(args: Array[String]): Unit = {
    val m1 = Array(Array(1, 2), Array(3, 4))
    val m2 = Array(Array(0, 5), Array(6, 7))
    println(kroneckerProduct(m1,m2).map(_.mkString("|")).mkString("\n"))

    println("----------")

    val m3 = Array(Array(0, 1, 0), Array(1, 1, 1), Array(0, 1, 0))
    val m4 = Array(Array(1, 1, 1, 1), Array(1, 0, 0, 1), Array(1, 1, 1, 1))
    println(kroneckerProduct(m3,m4).map(_.mkString("|")).mkString("\n"))
  }

}
