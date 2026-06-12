object OHalloranNumbers {

    @JvmStatic
    fun main(args: Array<String>) {
        val maximumArea = 1_000
        val halfMaximumArea = maximumArea / 2

        var ohalloranNumbers = BooleanArray(halfMaximumArea) { true }

        for (length in 1 until maximumArea) {
            for (width in 1 until halfMaximumArea) {
                for (height in 1 until halfMaximumArea) {
                    val halfArea = length * width + length * height + width * height
                    if (halfArea < halfMaximumArea) {
                        ohalloranNumbers[halfArea] = false
                    }
                }
            }
        }

        println("Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:")
        for (i in 3 until halfMaximumArea) {
            if (ohalloranNumbers[i]) {
                print("${i * 2} ")
            }
        }
        println()
    }
}

fun main() {
    OHalloranNumbers.main(arrayOf())
}
