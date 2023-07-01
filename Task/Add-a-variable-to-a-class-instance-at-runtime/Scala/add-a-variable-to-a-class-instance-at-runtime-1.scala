import language.dynamics
import scala.collection.mutable.HashMap

class A extends Dynamic {
  private val map = new HashMap[String, Any]
  def selectDynamic(name: String): Any = {
    return map(name)
  }
  def updateDynamic(name:String)(value: Any) = {
    map(name) = value
  }
}
