import scala.collection.mutable.PriorityQueue
case class Task(prio:Int, text:String) extends Ordered[Task] {
  def compare(that: Task)=that.prio compare this.prio
}

//test
var q=PriorityQueue[Task]() ++ Seq(Task(3, "Clear drains"), Task(4, "Feed cat"),
  Task(5, "Make tea"), Task(1, "Solve RC tasks"), Task(2, "Tax return"))
while(q.nonEmpty) println(q dequeue)
