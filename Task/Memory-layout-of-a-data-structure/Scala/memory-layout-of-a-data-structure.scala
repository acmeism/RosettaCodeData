object Rs232Pins9 extends App {

  val (off: Boolean, on: Boolean) = (false, true)
  val plug = new Rs232Pins9(carrierDetect = on, receivedData = on) // set first two pins, say

  def toOnOff(b: Boolean) = if (b) "on" else "off"

  class Rs232Pins9(
                    var carrierDetect: Boolean = off,
                    var receivedData: Boolean = off,
                    var transmittedData: Boolean = off,
                    var dataTerminalReady: Boolean = off,
                    var signalGround: Boolean = off,
                    var dataSetReady: Boolean = off,
                    var requestToSend: Boolean = off,
                    var clearToSend: Boolean = off,
                    var ringIndicator: Boolean = off
                  ) {
    def setPin(n: Int, v: Boolean) {
      (n) match {
        case 1 => carrierDetect = v
        case 2 => receivedData = v
        case 3 => transmittedData = v
        case 4 => dataTerminalReady = v
        case 5 => signalGround = v
        case 6 => dataSetReady = v
        case 7 => requestToSend = v
        case 8 => clearToSend = v
        case 9 => ringIndicator = v
      }
    }
  }

  // println(toOnOff(plug.component2()))                          // print value of pin 2 by number
  plug.transmittedData = on // set pin 3 by name
  plug.setPin(4, on) // set pin 4 by number
  // println(toOnOff(plug.component3()))                          // print value of pin 3 by number
  println(toOnOff(plug.dataTerminalReady)) // print value of pin 4 by name
  println(toOnOff(plug.ringIndicator)) // print value of pin 9 by name
}
