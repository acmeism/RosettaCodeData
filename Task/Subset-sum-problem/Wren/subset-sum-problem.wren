import "./fmt" for Fmt

class Item {
    construct new(word, weight) {
        _word = word
        _weight = weight
    }

    word { _word }
    weight { _weight }

    toString {Fmt.swrite("$-11s $4d", _word, _weight) }
}

var items = [
    Item.new("alliance",   -624),
    Item.new("archbishop", -915),
    Item.new("balm",        397),
    Item.new("bonnet",      452),
    Item.new("brute",       870),
    Item.new("centipede",  -658),
    Item.new("cobol",       362),
    Item.new("covariate",   590),
    Item.new("departure",   952),
    Item.new("deploy",       44),
    Item.new("diophantine", 645),
    Item.new("efferent",     54),
    Item.new("elysee",     -326),
    Item.new("eradicate",   376),
    Item.new("escritoire",  856),
    Item.new("exorcism",   -983),
    Item.new("fiat",        170),
    Item.new("filmy",      -874),
    Item.new("flatworm",    503),
    Item.new("gestapo",     915),
    Item.new("infra",      -847),
    Item.new("isis",       -982),
    Item.new("lindholm",    999),
    Item.new("markham",     475),
    Item.new("mincemeat",  -880),
    Item.new("moresby",     756),
    Item.new("mycenae",     183),
    Item.new("plugging",   -266),
    Item.new("smokescreen", 423),
    Item.new("speakeasy",  -745),
    Item.new("vein",        813)
]

var n = items.count
var indices = List.filled(n, 0)
var count = 0
var LIMIT = 5

var zeroSum // recursive
zeroSum = Fn.new { |i, w|
    if (i != 0 && w == 0) {
        for (j in 0...i) System.print("%(items[indices[j]]) ")
        System.print()
        if (count < LIMIT) {
            count = count + 1
        } else {
            return
        }
    }
    var k = (i != 0) ? indices[i-1] + 1 : 0
    var j = k
    while (j < n) {
        indices[i] = j
        zeroSum.call(i + 1, w + items[j].weight)
        if (count == LIMIT) return
        j = j + 1
    }
}

System.print("The weights of the following %(LIMIT) subsets add up to zero:\n")
zeroSum.call(0, 0)
