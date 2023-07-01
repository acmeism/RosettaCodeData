var maxPathLength = 0
var maxPathLengthCount = 0
var maxPathExample = ""

var names = [
    "audino", "bagon", "baltoy", "banette", "bidoof",
    "braviary", "bronzor", "carracosta", "charmeleon", "cresselia",
    "croagunk", "darmanitan", "deino", "emboar", "emolga",
    "exeggcute", "gabite", "girafarig", "gulpin", "haxorus",
    "heatmor", "heatran", "ivysaur", "jellicent", "jumpluff",
    "kangaskhan", "kricketune", "landorus", "ledyba", "loudred",
    "lumineon", "lunatone", "machamp", "magnezone", "mamoswine",
    "nosepass", "petilil", "pidgeotto", "pikachu", "pinsir",
    "poliwrath", "poochyena", "porygon2", "porygonz", "registeel",
    "relicanth", "remoraid", "rufflet", "sableye", "scolipede",
    "scrafty", "seaking", "sealeo", "silcoon", "simisear",
    "snivy", "snorlax", "spoink", "starly", "tirtouga",
    "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix",
    "wailord", "wartortle", "whismur", "wingull", "yamask"
]

var search // recursive function
search = Fn.new { |part, offset|
    if (offset > maxPathLength) {
        maxPathLength = offset
        maxPathLengthCount = 1
    } else if (offset == maxPathLength) {
        maxPathLengthCount = maxPathLengthCount + 1
        maxPathExample = ""
        for (i in 0...offset) {
            maxPathExample = maxPathExample + ((i % 5 == 0) ? "\n  " : " ") + part[i]
        }
    }
    var lastChar = part[offset - 1][-1]
    for (i in offset...part.count) {
        if (part[i][0] == lastChar) {
            var tmp = names[offset]
            names[offset] = names[i]
            names[i] = tmp
            search.call(names, offset + 1)
            names[i] = names[offset]
            names[offset] = tmp
        }
    }
}

for (i in 0...names.count) {
    var tmp = names[0]
    names[0] = names[i]
    names[i] = tmp
    search.call(names, 1)
    names[i] = names[0]
    names[0] = tmp
}
System.print("Maximum path length         : %(maxPathLength)")
System.print("Paths of that length        : %(maxPathLengthCount)")
System.print("Example path of that length : %(maxPathExample)")
