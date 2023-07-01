case class Task(prio:Int, text:String)
implicit def taskOrdering=new Ordering[Task] {
  def compare(t1:Task, t2:Task):Int=t2.prio compare t1.prio
}
