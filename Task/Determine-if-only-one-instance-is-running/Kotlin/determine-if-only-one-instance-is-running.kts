// version 1.0.6

import java.io.IOException
import java.net.*

object SingleInstance {
    private var ss: ServerSocket? = null

    fun alreadyRunning(): Boolean {
        try {
            ss = ServerSocket(65000, 10, InetAddress.getLocalHost()) // using private port 65000
        }
        catch (e: IOException) {
            // port already in use so an instance is already running
            return true
        }
        return false
    }

    fun close() {
        if (ss == null || ss?.isClosed() == true) return
        ss?.close()
    }
}

fun main(args: Array<String>) {
    if (SingleInstance.alreadyRunning()) {
        println("Application is already running, so terminating this instance")
        System.exit(0)
    }
    else {
        println("OK, only this instance is running but will terminate in 10 seconds")
        Thread.sleep(10000)
        SingleInstance.close()
    }
}
