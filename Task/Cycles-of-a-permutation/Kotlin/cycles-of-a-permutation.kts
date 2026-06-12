import java.util.*

enum class Day(val letters: String) {
    MONDAY("HANDYCOILSERUPT"),
    TUESDAY("SPOILUNDERYACHT"),
    WEDNESDAY("DRAINSTYLEPOUCH"),
    THURSDAY("DITCHSYRUPALONE"),
    FRIDAY("SOAPYTHIRDUNCLE"),
    SATURDAY("SHINEPARTYCLOUD"),
    SUNDAY("RADIOLUNCHTYPES");

    fun previous(): Day {
        return days.lower(this) ?: days.last()
    }

    companion object {
        private val days = TreeSet(values().toSet())
    }
}

fun main() {

    val permutation = Permutation(Day.MONDAY.letters.length)

    println("On Thursdays Alf and Betty should rearrange their letters using these cycles:")
    val oneLineWedThu = permutation.createOneLine(Day.WEDNESDAY.letters, Day.THURSDAY.letters)
    val cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu)
    println(cyclesWedThu)
    println("So that ${Day.WEDNESDAY.letters} becomes ${Day.THURSDAY.letters}")

    println("\nOr they could use the one line notation:")
    println(oneLineWedThu)

    println("\nTo revert to the Wednesday arrangement they should use these cycles:")
    val cyclesThuWed = permutation.cyclesInverse(cyclesWedThu)
    println(cyclesThuWed)

    println("\nOr with the one line notation:")
    val oneLineThuWed = permutation.oneLineInverse(oneLineWedThu)
    println(oneLineThuWed)
    println("So that ${Day.THURSDAY.letters} becomes ${permutation.oneLinePermuteString(Day.THURSDAY.letters, oneLineThuWed)}")

    println("\nStarting with the Sunday arrangement and applying each of the daily")
    println("arrangements consecutively, the arrangements will be:")
    println("\n      ${Day.SUNDAY.letters}\n")

    for (day in Day.values()) {
        val dayOneLine = permutation.createOneLine(day.previous().letters, day.letters)
        val result = permutation.oneLinePermuteString(day.previous().letters, dayOneLine)
        println("${day.name.padStart(11)}: $result${if (day == Day.SATURDAY) "\n" else ""}")
    }

    println("\nTo go from Wednesday to Friday in a single step they should use these cycles:")
    val oneLineThuFri = permutation.createOneLine(Day.THURSDAY.letters, Day.FRIDAY.letters)
    val cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri)
    val cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri)
    println(cyclesWedFri)
    println("So that ${Day.WEDNESDAY.letters} becomes ${permutation.cyclesPermuteString(Day.WEDNESDAY.letters, cyclesWedFri)}")

    println("\nThese are the signatures of the permutations:\n")
    for (day in Day.values()) {
        val oneLine = permutation.createOneLine(day.previous().letters, day.letters)
        println("${day.name.padStart(11)}: ${permutation.signature(oneLine)}")
    }

    println("\nThese are the orders of the permutations:\n")
    for (day in Day.values()) {
        val oneLine = permutation.createOneLine(day.previous().letters, day.letters)
        println("${day.name.padStart(11)}: ${permutation.order(oneLine)}")
    }

    println("\nApplying the Friday cycle to a string 10 times:")
    var word = "STOREDAILYPUNCH"
    println("\n 0 $word\n")
    for (i in 1..10) {
        word = permutation.cyclesPermuteString(word, cyclesThuFri)
        println("${i.toString().padStart(2)} $word${if (i == 9) "\n" else ""}")
    }
}

class Permutation(private val lettersCount: Int) {

    // Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    fun createOneLine(source: String, destination: String): MutableList<Int> {
        val result = mutableListOf<Int>()
        for (ch in destination) {
            result.add(source.indexOf(ch) + 1)
        }

        while (result.isNotEmpty() && result.last() == result.size) {
            result.removeAt(result.size - 1)
        }
        return result
    }

    // Return the cycles of the permutation given in one line form.
    fun oneLineToCycles(oneLine: List<Int>): MutableList<MutableList<Int>> {
        val cycles = mutableListOf<MutableList<Int>>()
        val used = mutableSetOf<Int>()

        var number = 1
        while (used.size < oneLine.size) {
            if (number !in used) {
                var index = oneLine.indexOf(number) + 1

                if (index > 0) {
                    val cycle = mutableListOf<Int>()
                    cycle.add(number)

                    while (number != index) {
                        cycle.add(index)
                        index = oneLine.indexOf(index) + 1
                    }

                    if (cycle.size > 1) {
                        cycles.add(cycle)
                    }
                    used.addAll(cycle)
                }
            }
            number++
        }

        return cycles
    }

    // Return the one line notation of the permutation given in cycle form.
    fun cyclesToOneLine(cycles: List<List<Int>>): MutableList<Int> {
        val oneLine = (1..lettersCount).toMutableList()

        for (number in 1..lettersCount) {
            for (cycle in cycles) {
                val index = cycle.indexOf(number)
                if (index >= 0) {
                    oneLine[number - 1] = cycle[(index - 1 + cycle.size) % cycle.size]
                    break
                }
            }
        }

        return oneLine
    }

    // Return the inverse of the given permutation in cycle form.
    fun cyclesInverse(cycles: List<List<Int>>): MutableList<MutableList<Int>> {
        val cyclesInverse = cycles.map { it.toMutableList() }.toMutableList()

        for (cycle in cyclesInverse) {
            val first = cycle.removeAt(0)
            cycle.add(first)
            cycle.reverse()
        }

        return cyclesInverse
    }

    // Return the inverse of the given permutation in one line notation.
    fun oneLineInverse(oneLine: List<Int>): MutableList<Int> {
        val oneLineInverse = MutableList(oneLine.size) { 0 }
        for (number in 1..oneLine.size) {
            oneLineInverse[number - 1] = oneLine.indexOf(number) + 1
        }

        return oneLineInverse
    }

    // Return the cycles obtained by composing cycleOne first followed by cycleTwo.
    fun combinedCycles(cyclesOne: List<List<Int>>, cyclesTwo: List<List<Int>>): MutableList<MutableList<Int>> {
        val combinedCycles = mutableListOf<MutableList<Int>>()
        val used = mutableSetOf<Int>()

        var number = 1
        while (used.size < lettersCount) {
            if (number !in used) {
                var combined = next(next(number, cyclesOne), cyclesTwo)
                val cycle = mutableListOf<Int>()
                cycle.add(number)

                while (number != combined) {
                    cycle.add(combined)
                    combined = next(next(combined, cyclesOne), cyclesTwo)
                }

                if (cycle.size > 1) {
                    combinedCycles.add(cycle)
                }
                used.addAll(cycle)
            }
            number++
        }

        return combinedCycles
    }

    // Return the given string permuted by the permutation given in one line form.
    fun oneLinePermuteString(text: String, oneLine: List<Int>): String {
        val permuted = mutableListOf<String>()

        for (index in oneLine) {
            permuted.add(text.substring(index - 1, index))
        }

        permuted.add(text.substring(permuted.size))

        return permuted.joinToString("")
    }

    // Return the given string permuted by the permutation given in cycle form.
    fun cyclesPermuteString(text: String, cycles: List<List<Int>>): String {
        val permuted = text.map { it.toString() }.toMutableList()

        for (cycle in cycles) {
            for (number in cycle) {
                permuted[next(number, cycles) - 1] = text.substring(number - 1, number)
            }
        }

        return permuted.joinToString("")
    }

    // Return the signature of the permutation given in one line form.
    fun signature(oneLine: List<Int>): String {
        val cycles = oneLineToCycles(oneLine)
        val evenCount = cycles.count { it.size % 2 == 0 }
        return if (evenCount % 2 == 0) "+1" else "-1"
    }

    // Return the order of the permutation given in one line form.
    fun order(oneLine: List<Int>): Int {
        val cycles = oneLineToCycles(oneLine)
        val sizes = cycles.map { it.size }
        return sizes.fold(1) { acc, size -> acc * (size / gcd(acc, size)) }
    }

    // Return the element to which the given number is mapped by the permutation given in cycle form.
    private fun next(number: Int, cycles: List<List<Int>>): Int {
        for (cycle in cycles) {
            if (number in cycle) {
                return cycle[(cycle.indexOf(number) + 1) % cycle.size]
            }
        }
        return number
    }

    // Return the greatest common divisor of the two given numbers.
    private tailrec fun gcd(one: Int, two: Int): Int {
        return if (two == 0) one else gcd(two, one % two)
    }
}
