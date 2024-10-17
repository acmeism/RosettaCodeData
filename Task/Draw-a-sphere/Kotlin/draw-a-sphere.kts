// version 1.0.6

const val shades = ".:!*oe&#%@"
val light  = doubleArrayOf(30.0, 30.0, -50.0)

fun normalize(v: DoubleArray) {
    val len = Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2])
    v[0] /= len; v[1] /= len; v[2] /= len
}

fun dot(x: DoubleArray, y: DoubleArray): Double {
    val d = x[0] * y[0] + x[1] * y[1] + x[2] * y[2]
    return if (d < 0.0) -d else 0.0
}

fun drawSphere(r: Double, k: Double, ambient: Double) {
    val vec = DoubleArray(3)
    var intensity: Int
    var b : Double
    var x: Double
    var y: Double
    for (i in Math.floor(-r).toInt() .. Math.ceil(r).toInt()) {
        x = i + 0.5
        for (j in Math.floor(-2.0 * r).toInt() .. Math.ceil(2.0 * r).toInt()) {
            y = j / 2.0 + 0.5
            if (x * x + y * y <= r * r) {
                vec[0] = x
                vec[1] = y
                vec[2] = Math.sqrt(r * r - x * x - y * y)
                normalize(vec)
                b = Math.pow(dot(light, vec), k) + ambient
                intensity = ((1.0 - b) * (shades.length - 1)).toInt()
                if (intensity < 0) intensity = 0
                if (intensity >= shades.length - 1) intensity = shades.length - 2
                print(shades[intensity])
            }
            else print(' ')
        }
        println()
    }
}

fun main(args: Array<String>) {
    normalize(light)
    drawSphere(20.0, 4.0, 0.1)
    drawSphere(10.0, 2.0, 0.4)
}
