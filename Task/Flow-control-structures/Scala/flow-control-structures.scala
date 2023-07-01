import Goto._
import scala.util.continuations._

object Goto {

  case class Label(k: Label => Unit)

  private case class GotoThunk(label: Label) extends Throwable

  def label: Label @suspendable =
    shift((k: Label => Unit) => executeFrom(Label(k)))

  def goto(l: Label): Nothing =
    throw new GotoThunk(l)

  private def executeFrom(label: Label): Unit = {
    val nextLabel = try {
      label.k(label)
      None
    } catch {
      case g: GotoThunk => Some(g.label)
    }
    if (nextLabel.isDefined) executeFrom(nextLabel.get)
  }

}
