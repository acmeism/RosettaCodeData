import scala.io.Source

object parseCSV extends App {

  val rawData = """|C1,C2,C3,C4,C5
		  		   |1,5,9,13,17
		  		   |2,6,10,14,18
		  		   |3,7,11,15,19
		  		   |20,21,22,23,24""".stripMargin

  val data = Seq((Source.fromString(rawData).getLines()).map(_.split(",")).toSeq: _*)

  val output = ((data.take(1).flatMap(x => x) :+ "SUM").mkString(",") +: // Header line
    data.drop(1).map(_.map(_.toInt)). // Convert per line each array of String to array of integer
    map(cells => (cells, cells.sum)). //Add sum column to assemble a tuple. Part 1 are original numbers, 2 is the sum
    map(part => s"${part._1.mkString(",")},${part._2}")).mkString("\n")

  println(output)
  /* Outputs:

C1,C2,C3,C4,C5,SUM
1,5,9,13,17,45
2,6,10,14,18,50
3,7,11,15,19,55
20,21,22,23,24,110

*/
}
