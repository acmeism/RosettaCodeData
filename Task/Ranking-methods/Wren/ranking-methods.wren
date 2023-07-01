import "/math" for Nums
import "/fmt" for Fmt

/* all ranking functions assume the array of Pairs is non-empty and already sorted
   by decreasing order of scores and then, if the scores are equal, by reverse
   alphabetic order of names
*/

var standardRanking = Fn.new { |scores|
    var rankings = List.filled(scores.count, 0)
    rankings[0] = 1
    for (i in 1...scores.count) {
        rankings[i] = (scores[i][0] == scores[i-1][0]) ? rankings[i-1] : i + 1
    }
    return rankings
}

var modifiedRanking = Fn.new { |scores|
    var rankings = List.filled(scores.count, 0)
    rankings[0] = 1
    for (i in 1...scores.count) {
        rankings[i] =  i + 1
        var currScore = scores[i][0]
        for (j in i-1..0) {
            if (currScore != scores[j][0]) break
            rankings[j] = i + 1
        }
    }
    return rankings
}

var denseRanking = Fn.new { |scores|
    var rankings = List.filled(scores.count, 0)
    rankings[0] = 1
    var prevRanking = 1
    for (i in 1...scores.count) {
        rankings[i] = (scores[i][0] == scores[i-1][0]) ? prevRanking : (prevRanking = prevRanking+1)
    }
    return rankings
}

var ordinalRanking = Fn.new { |scores| (1..scores.count).toList }

var fractionalRanking = Fn.new { |scores|
    var rankings = List.filled(scores.count, 0)
    rankings[0] = 1
    for (i in 1...scores.count) {
        var k = i
        var currScore = scores[i][0]
        for (j in i-1..0) {
            if (currScore != scores[j][0]) break
            k = j
        }
        var avg = Nums.mean(k..i) + 1
        for (m in k..i) rankings[m] = avg
    }
    return rankings
}

var printRankings = Fn.new { |title, rankings, scores|
    System.print(title + ":")
    for (i in 0...rankings.count) {
        System.print("%(rankings[i])  %(scores[i][0]) %(scores[i][1])")
    }
    System.print()
}

var printFractionalRankings = Fn.new { |title, rankings, scores|
    System.print(title + ":")
    for (i in 0...rankings.count) {
        Fmt.print("$3.2f  $d $s", rankings[i], scores[i][0], scores[i][1])
    }
    System.print()
}

var scores = [[44, "Solomon"], [42, "Jason"], [42, "Errol"],  [41, "Garry"],
              [41, "Bernard"], [41, "Barry"], [39, "Stephen"]]
printRankings.call("Standard ranking", standardRanking.call(scores), scores)
printRankings.call("Modified ranking", modifiedRanking.call(scores), scores)
printRankings.call("Dense ranking", denseRanking.call(scores), scores)
printRankings.call("Ordinal ranking", ordinalRanking.call(scores), scores)
printFractionalRankings.call("Fractional ranking", fractionalRanking.call(scores), scores)
