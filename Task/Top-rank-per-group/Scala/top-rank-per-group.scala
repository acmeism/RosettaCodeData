object TopRank extends Application {
	import scala.io._
	val data = """Tyler Bennett,E10297,32000,D101
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

	class Employee(val name:String, val id:String, val salary:Int, val department:String) {
		override def toString = id +"\t"+salary+"\t"+name
	}
	Source.fromString(data).getLines().map(_.split(",")).map(x => new Employee(x(0), x(1), x(2).toInt, x(3) )).toList // read data into list of employees
		.sortBy(x => (x.department, -x.salary)).groupBy(_.department).foreach{ group =>  // sort and group by
			println("Department: "+group._1)
			group._2.take(3).foreach{x =>  println("\t"+x) }
	}
}
