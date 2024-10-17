// version 1.0.6

const val OFF = false
const val ON  = true

fun toOnOff(b: Boolean) = if (b) "ON" else "OFF"

data class Rs232Pins9(
    var carrierDetect     : Boolean = OFF,
    var receivedData      : Boolean = OFF,
    var transmittedData   : Boolean = OFF,
    var dataTerminalReady : Boolean = OFF,
    var signalGround      : Boolean = OFF,
    var dataSetReady      : Boolean = OFF,
    var requestToSend     : Boolean = OFF,
    var clearToSend       : Boolean = OFF,
    var ringIndicator     : Boolean = OFF
) {
    fun setPin(n: Int, v: Boolean) {
        when (n) {
            1 -> carrierDetect     = v
            2 -> receivedData      = v
            3 -> transmittedData   = v
            4 -> dataTerminalReady = v
            5 -> signalGround      = v
            6 -> dataSetReady      = v
            7 -> requestToSend     = v
            8 -> clearToSend       = v
            9 -> ringIndicator     = v
        }
    }
}

fun main(args: Array<String>) {
    val plug = Rs232Pins9(carrierDetect = ON, receivedData = ON) // set first two pins, say
    println(toOnOff(plug.component2()))                          // print value of pin 2 by number
    plug.transmittedData = ON                                    // set pin 3 by name
    plug.setPin(4, ON)                                           // set pin 4 by number
    println(toOnOff(plug.component3()))                          // print value of pin 3 by number
    println(toOnOff(plug.dataTerminalReady))                     // print value of pin 4 by name
    println(toOnOff(plug.ringIndicator))                         // print value of pin 9 by name
}
