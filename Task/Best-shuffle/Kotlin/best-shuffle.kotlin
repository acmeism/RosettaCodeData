import java.util.Random

object BestShuffle {
    operator fun invoke(s1: String) : String {
        val s2 = s1.toCharArray()
        s2.shuffle()
        for (i in s2.indices)
            if (s2[i] == s1[i])
                for (j in s2.indices)
                    if (s2[i] != s2[j] && s2[i] != s1[j] && s2[j] != s1[i]) {
                        val tmp = s2[i]
                        s2[i] = s2[j]
                        s2[j] = tmp
                        break
                    }
        return s1 + ' ' + String(s2) + " (" + s2.count(s1) + ')'
    }

    private fun CharArray.shuffle() {
        val rand = Random()
        for (i in size - 1 downTo 1) {
            val r = rand.nextInt(i + 1)
            val tmp = this[i]
            this[i] = this[r]
            this[r] = tmp
        }
    }

    private fun CharArray.count(s1: String) : Int {
        var count = 0
        for (i in indices)
            if (s1[i] == this[i]) count++
        return count
    }
}

fun main(words: Array<String>) = words.forEach { println(BestShuffle(it)) }
