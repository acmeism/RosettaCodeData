import "random" for Random
import "/fmt" for Fmt

var letters  = ["aleph", "beth", "gimel", "daleth", "he", "waw", "zayin", "heth"]
var actual   = [0] * 8
var probs    = [1/5, 1/6, 1/7, 1/8, 1/9, 1/10, 1/11, 0]
var cumProbs = [0] * 8

cumProbs[0] = probs[0]
for (i in 1..6) cumProbs[i] = cumProbs[i-1] + probs[i]
cumProbs[7] = 1
probs[7] = 1 - cumProbs[6]
var n = 1e6
var rand = Random.new()
(1..n).each { |i|
    var r = rand.float()
    var index = (r <= cumProbs[0]) ? 0 :
                (r <= cumProbs[1]) ? 1 :
                (r <= cumProbs[2]) ? 2 :
                (r <= cumProbs[3]) ? 3 :
                (r <= cumProbs[4]) ? 4 :
                (r <= cumProbs[5]) ? 5 :
                (r <= cumProbs[6]) ? 6 : 7
    actual[index] = actual[index] + 1
}

var sumActual = 0
System.print("Letter\t Actual    Expected")
System.print("------\t--------   --------")
for (i in 0..7) {
    var generated = actual[i]/n
    Fmt.print("$s\t$8.6f   $8.6f", letters[i], generated, probs[i])
    sumActual = sumActual + generated
}
System.print("\t--------   --------")
Fmt.print("\t$8.6f   1.000000", sumActual)
