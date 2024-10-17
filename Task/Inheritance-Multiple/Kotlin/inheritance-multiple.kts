interface Camera {
    val numberOfLenses : Int
}

interface MobilePhone {
    fun charge(n : Int) {
        if (n >= 0)
            battery_level = (battery_level + n).coerceAtMost(100)
    }

    var battery_level : Int
}

data class CameraPhone(override val numberOfLenses : Int = 1, override var battery_level: Int) : Camera, MobilePhone
data class TwinLensCamera(override val numberOfLenses : Int = 2) : Camera

fun main(args: Array<String>) {
    val c = CameraPhone(1, 50)
    println(c)
    c.charge(35)
    println(c)
    c.charge(78)
    println(c)
    println(listOf(c.javaClass.superclass) + c.javaClass.interfaces)
    val c2 = TwinLensCamera()
    println(c2)
    println(listOf(c2.javaClass.superclass) + c2.javaClass.interfaces)
}
