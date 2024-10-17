val playOptimal: () -> Boolean = {
    val secrets = (0..99).toMutableList()
    var ret = true
    secrets.shuffle()
    prisoner@ for(i in 0 until 100){
        var prev = i
        draw@ for(j in 0 until  50){
            if (secrets[prev] == i) continue@prisoner
            prev = secrets[prev]
        }
        ret = false
        break@prisoner
    }
    ret
}

val playRandom: ()->Boolean = {
    var ret = true
    val secrets = (0..99).toMutableList()
    secrets.shuffle()
    prisoner@ for(i in 0 until 100){
        val opened = mutableListOf<Int>()
        val genNum : () ->Int = {
            var r = (0..99).random()
            while (opened.contains(r)) {
                r = (0..99).random()
            }
            r
        }
        for(j in 0 until 50){
            val draw = genNum()
            if ( secrets[draw] == i) continue@prisoner
            opened.add(draw)
        }
        ret = false
        break@prisoner
    }
    ret
}

fun exec(n:Int, play:()->Boolean):Double{
    var succ = 0
    for (i in IntRange(0, n-1)){
        succ += if(play()) 1 else 0
    }
    return (succ*100.0)/n
}

fun main() {
    val N = 100_000
    println("# of executions: $N")
    println("Optimal play success rate: ${exec(N, playOptimal)}%")
    println("Random play success rate: ${exec(N, playRandom)}%")
}
