object TopicVar extends App {
  class SuperString(val org: String){
    def it(): Unit = println(org)
  }

  new SuperString("FvdB"){it()}
  new SuperString("FvdB"){println(org)}

  Seq(1).foreach {println}
  Seq(2).foreach {println(_)}
  Seq(4).foreach { it => println(it)}
  Seq(8).foreach { it => println(it + it)}
}
