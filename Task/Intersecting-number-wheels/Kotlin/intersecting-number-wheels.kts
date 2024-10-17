import java.util.Collections
import java.util.stream.IntStream

object WheelController {
    private val IS_NUMBER = "[0-9]".toRegex()
    private const val TWENTY = 20
    private var wheelMap = mutableMapOf<String, WheelModel>()

    private fun advance(wheel: String) {
        val w = wheelMap[wheel]
        if (w!!.list[w.position].matches(IS_NUMBER)) {
            w.printThePosition()
        } else {
            val wheelName = w.list[w.position]
            advance(wheelName)
        }
        w.advanceThePosition()
    }

    private fun run() {
        println(wheelMap)
        IntStream.rangeClosed(1, TWENTY)
            .forEach { advance("A") }
        println()
        wheelMap.clear()
    }

    @JvmStatic
    fun main(args: Array<String>) {
        wheelMap["A"] = WheelModel("1", "2", "3")
        run()
        wheelMap["A"] = WheelModel("1", "B", "2")
        wheelMap["B"] = WheelModel("3", "4")
        run()
        wheelMap["A"] = WheelModel("1", "D", "D")
        wheelMap["D"] = WheelModel("6", "7", "8")
        run()
        wheelMap["A"] = WheelModel("1", "B", "C")
        wheelMap["B"] = WheelModel("3", "4")
        wheelMap["C"] = WheelModel("5", "B")
        run()
    }
}

internal class WheelModel(vararg values: String?) {
    var list = mutableListOf<String>()
    var position: Int
    private var endPosition: Int

    override fun toString(): String {
        return list.toString()
    }

    fun advanceThePosition() {
        if (position == endPosition) {
            position = INITIAL // new beginning
        } else {
            position++ // advance position
        }
    }

    fun printThePosition() {
        print(" ${list[position]}")
    }

    companion object {
        private const val INITIAL = 0
    }

    init {
        Collections.addAll<String>(list, *values)
        position = INITIAL
        endPosition = list.size - 1
    }
}
