import "/fmt" for Fmt

var averageSquareDiff = Fn.new { |f, preds|
    var av = 0
    for (pred in preds) av = av + (pred-f)*(pred-f)
    return av/preds.count
}

var diversityTheorem = Fn.new { |truth, preds|
    var av = (preds.reduce { |sum, pred| sum + pred }) / preds.count
    var avErr = averageSquareDiff.call(truth, preds)
    var crowdErr = (truth-av) * (truth-av)
    var div = averageSquareDiff.call(av, preds)
    return [avErr, crowdErr, div]
}

var predsList = [ [48, 47, 51], [48, 47, 51, 42] ]
var truth = 49
for (preds in predsList) {
    var res = diversityTheorem.call(truth, preds)
    Fmt.print("Average-error : $6.3f", res[0])
    Fmt.print("Crowd-error   : $6.3f", res[1])
    Fmt.print("Diversity     : $6.3f\n", res[2])
}
