object ForestFire{
  def main(args: Array[String]): Unit = {
    var l=Forest()
    for(i <- 0 until 20){
      println(l+"\n-----------------------")
      l=l.evolve
    }
  }
}
