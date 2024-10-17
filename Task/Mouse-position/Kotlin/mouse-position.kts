// version 1.1.2

import java.awt.MouseInfo

fun main(args: Array<String>) {
    (1..5).forEach {
        Thread.sleep(1000)
        val p = MouseInfo.getPointerInfo().location  // gets screen coordinates
        println("${it}: x = ${"%-4d".format(p.x)} y = ${"%-4d".format(p.y)}")
    }
}
