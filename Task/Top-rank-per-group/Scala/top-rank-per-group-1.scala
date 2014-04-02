import scala.io.Source
import scala.language.implicitConversions
import scala.language.reflectiveCalls
import scala.collection.immutable.TreeMap

object TopRank extends App {
  val topN = 3

  val rawData = """Employee Name;Employee ID;Salary;Department
			   |Tyler Bennett;E10297;32000;D101
			   |John Rappl;E21437;47000;D050
			   |George Woltman;E00127;53500;D101
			   |Adam Smith;E63535;18000;D202
			   |Claire Buckman;E39876;27800;D202
			   |David McClellan;E04242;41500;D101
			   |Rich Holcomb;E01234;49500;D202
			   |Nathan Adams;E41298;21900;D050
			   |Richard Potter;E43128;15900;D101
			   |David Motsinger;E27002;19250;D202
			   |Tim Sampair;E03033;27000;D101
			   |Kim Arlich;E10001;57000;D190
			   |Timothy Grove;E16398;29900;D190""".stripMargin

  class Employee(name: String, id: String,
                 val salary: Int,
                 val department: String) {
    override def toString = s"$id\t$salary\t$name"
  }

  // A TreeMap has sorted keys
  val data: TreeMap[String, Seq[TopRank.Employee]] = // TreeMap is a sorted map
    TreeMap((Source.fromString(rawData) getLines ()).toSeq // Runtime parsing
      .drop(1) // Drop header
      .map(_.split(";")) //read fields into list of employees
      .map(emp => new Employee(emp(0), emp(1), emp(2).toInt, emp(3)))
      .groupBy(_.department).toSeq: _*)

  implicit def iterableWithAvg[T: Numeric](data: Iterable[T]) = new {
    def average[T](ts: Iterable[T])(implicit num: Numeric[T]) = {
      num.toDouble(ts.sum) / ts.size
    }
    def avg = average(data)
  }

  val a = data.flatMap { case (_, emps) => emps.map(_.salary) }.avg

  println(s"Reporting top $topN salaries in each department.\n")

  println(s"Total of ${data.foldLeft(0)(_ + _._2.size)} employees in ${data.size} departments")

  println(f"Average salary: $a%8.2f\n")

  data.foreach {
    case (dep, emps) => println(f"Department: $dep  pop: ${emps.size} avg: ${emps.map(_.salary).avg}%8.2f\n"
      + emps.sortBy(-_.salary).take(topN)
      .map(_.toString).mkString("\t", "\n\t", ""))
  }
}
