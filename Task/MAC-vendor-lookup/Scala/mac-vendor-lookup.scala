object LookUp extends App {
  val macs = Seq("FC-A1-3E", "FC:FB:FB:01:FA:21", "88:53:2E:67:07:BE", "D4:F4:6F:C9:EF:8D")

  def lookupVendor(mac: String) =
    scala.io.Source.fromURL("""http://api.macvendors.com/""" + mac, "UTF-8").mkString

  macs.foreach(mac => println(lookupVendor(mac)))
}
