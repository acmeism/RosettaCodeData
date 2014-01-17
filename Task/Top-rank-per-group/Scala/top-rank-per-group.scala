import scala.io._

object TopRank extends App {
  val data = """Employee Name,Employee ID,Salary,Department
Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190"""

  class Employee(val name: String,
                 val id: String,
                 val salary: Int,
                 val department: String) {
    override def toString = s"$id\t$salary\t$name"
  }

  (for { x <- (Source.fromString(data).getLines().drop(1).map(_.split(","))) }
    yield new Employee(x(0), x(1), x(2).toInt, x(3))) // read data into list of employees
    .toList.sortBy(x => (x.department, -x.salary))
    .groupBy(_.department) // sort and group by
    .foreach {
      case (dep, emps) => println(s"Department: $dep\n"
        + emps.take(3).map(_.toString).mkString("\t", "\n\t", ""))
    }
}
