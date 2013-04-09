import scala.util.Random

class Forest(matrix:Array[Array[Char]]){
  import Forest._
  val f=0.01;	 // auto combustion probability
  val p=0.1;	 // tree creation probability
  val rows=matrix.size
  val cols=matrix(0).size

  def evolve():Forest=new Forest(Array.tabulate(rows, cols){(y,x)=>
    matrix(y)(x) match {
      case EMPTY => if (Random.nextDouble<p) TREE else EMPTY
      case BURNING => EMPTY
      case TREE => if (neighbours(x, y).exists(_==BURNING)) BURNING
                  else if (Random.nextDouble<f) BURNING else TREE
    }
  })

  def neighbours(x:Int, y:Int)=matrix slice(y-1, y+2) map(_.slice(x-1, x+2)) flatten
  override def toString()=matrix map (_.mkString("")) mkString "\n"
}

object Forest{
  val TREE='T'
  val BURNING='#'
  val EMPTY='.'
  def apply(x:Int=30, y:Int=15)=new Forest(Array.tabulate(y, x)((y,x)=> if (Random.nextDouble<0.5) TREE else EMPTY))
}
