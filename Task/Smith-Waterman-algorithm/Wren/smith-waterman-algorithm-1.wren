import "./ioutil" for FileUtil
import "./math" for Math, Nums

class BLOSUM62 {
    construct new() {
        _scoringMatrix = {}
        var lines = FileUtil.readLines("BLOSUM62.txt")
        for (line in lines) {
            var entry = line.trim().split(" ")
            if (entry.count >= 3) {
                var key = entry[0] + "," + entry[1]
                _scoringMatrix[key] = Num.fromString(entry[2])
            }
        }
    }

    getItem(pair) {
        var key = pair[0] + "," + pair[1]
        return _scoringMatrix[key]
    }
}

var localAlignment = Fn.new { |v, w, scoringMatrix, gapStart, gapExtend|
    // Initialize the matrices.
    var M = List.filled(v.count + 1, null)
    var X = List.filled(v.count + 1, null)
    var Y = List.filled(v.count + 1, null)
    var B = List.filled(v.count + 1, null)  // back-track
    for (i in 0..v.count) {
        M[i] = List.filled(w.count + 1, 0)
        X[i] = List.filled(w.count + 1, 0)
        Y[i] = List.filled(w.count + 1, 0)
        B[i] = List.filled(w.count + 1, 0)
    }

    // Initialize the maximum scores.
    var maxScore = -1
    var maxI = 0
    var maxJ = 0

    // Populate the matrices.
    for (i in 1..v.count) {
        for (j in 1..w.count) {
            Y[i][j] = Math.max(Y[i-1][j] - gapExtend, M[i-1][j] - gapStart)
            X[i][j] = Math.max(X[i][j-1] - gapExtend, M[i][j-1] - gapStart)

            var curScores = [
                Y[i][j],
                M[i-1][j-1] + scoringMatrix.getItem([v[i-1], w[j-1]]),
                X[i][j],
                0
            ]
            M[i][j] = Nums.max(curScores)
            B[i][j] = curScores.indexOf(M[i][j])

            if (M[i][j] > maxScore) {
                maxScore = M[i][j]
                maxI = i
                maxJ = j
            }
        }
    }

    System.print("Finished making the matrix")

    // Initialize the indices to start at the position of the high score.
    var i = maxI
    var j = maxJ

    // Initialize the aligned strings as the input strings up to the position of the high score.
    var vAligned = v[0...i]
    var wAligned = w[0...j]

    // Backtrack to start of the local alignment starting at the highest scoring cell.
    while (B[i][j] != 3 && i * j != 0 && i >= j) {
        if (B[i][j] == 0) {
            i = i - 1
        } else if (B[i][j] == 1) {
            i = i - 1
            j = j - 1
        } else if (B[i][j] == 2) {
            j = j - 1
        }
    }

    System.print("finished backtracking")

    // Cut the strings at the ending point of the backtrack.
    vAligned = vAligned[i..-1]
    wAligned = wAligned[j..-1]

    return [maxScore.toString, vAligned, wAligned]
}

// Read the input file.
var indata = FileUtil.readLines("sw_input.txt")
indata.add(">")

var word1 = ""
var word2 = ""
var linenum = 0
var chunk = []

for (line in indata) {
    var trimmedLine = line.trim()
    linenum = linenum + 1

    if (trimmedLine == "") {
        continue
    } else {
        if (trimmedLine[0] == ">") {
            if (linenum == 1) {
                chunk = []
            } else if (linenum > 1 && linenum != indata.count) {
                word1 = chunk.join("")
                chunk = []
            } else {
                word2 = chunk.join("")
            }
        } else {
            chunk.add(trimmedLine)
        }
    }
}

// Get the local alignment (given sigma = 11, epsilon = 1 in problem statement).
var blosum = BLOSUM62.new()
var alignment = localAlignment.call(word1, word2, blosum, 11, 1)

// Print and save the answer.
System.print(alignment.join("\n"))

FileUtil.write("sw_output.txt", alignment.toString())
