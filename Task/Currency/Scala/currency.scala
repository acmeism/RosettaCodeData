import java.text.NumberFormat
import java.util.Locale

object SizeMeUp extends App {

  val menu: Map[String, (String, Double)] = Map("burg" ->("Hamburger XL", 5.50), "milk" ->("Milkshake", 2.86))
  val order = List((4000000000000000L, "burg"), (2L, "milk"))

  Locale.setDefault(new Locale("ru", "RU"))

  val (currSymbol, tax) = (NumberFormat.getInstance().getCurrency.getSymbol, 0.0765)

  def placeOrder(order: List[(Long, String)]) = {
    val totals = for ((qty, article) <- order) yield {
      val (desc, itemPrize) = menu(article)
      val (items, post) = (qty, qty * BigDecimal(itemPrize))
      println(f"$qty%16d\t$desc%-16s\t$currSymbol%4s$itemPrize%6.2f\t$post%,25.2f")
      (items, post)
    }
    totals.foldLeft((0L, BigDecimal(0))) { (acc, n) => (acc._1 + n._1, acc._2 + n._2)}
  }

  val (items, beforeTax) = placeOrder(order)

  println(f"$items%16d\t${"ordered items"}%-16s${'\t' + "  Subtotal" + '\t'}$beforeTax%,25.2f")

  val taxation = beforeTax * tax
  println(f"${" " * 16 + '\t' + " " * 16 + '\t' + f"${tax * 100}%5.2f%% tax" + '\t'}$taxation%,25.2f")
  println(f"${" " * 16 + '\t' + " " * 16 + '\t' + "Amount due" + '\t'}${beforeTax + taxation}%,25.2f")
}
