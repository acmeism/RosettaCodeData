import "./dynamic" for Struct

var mPref = {
    "abe": [
        "abi", "eve", "cath", "ivy", "jan",
        "dee", "fay", "bea", "hope", "gay"],
    "bob": [
        "cath", "hope", "abi", "dee", "eve",
        "fay", "bea", "jan", "ivy", "gay"],
    "col": [
        "hope", "eve", "abi", "dee", "bea",
        "fay", "ivy", "gay", "cath", "jan"],
    "dan": [
        "ivy", "fay", "dee", "gay", "hope",
        "eve", "jan", "bea", "cath", "abi"],
    "ed": [
        "jan", "dee", "bea", "cath", "fay",
        "eve", "abi", "ivy", "hope", "gay"],
    "fred": [
        "bea", "abi", "dee", "gay", "eve",
        "ivy", "cath", "jan", "hope", "fay"],
    "gav": [
        "gay", "eve", "ivy", "bea", "cath",
        "abi", "dee", "hope", "jan", "fay"],
    "hal": [
        "abi", "eve", "hope", "fay", "ivy",
        "cath", "jan", "bea", "gay", "dee"],
    "ian": [
        "hope", "cath", "dee", "gay", "bea",
        "abi", "fay", "ivy", "jan", "eve"],
    "jon": [
        "abi", "fay", "jan", "gay", "eve",
        "bea", "dee", "cath", "ivy", "hope"]
}

var wPref = {
    "abi": {
        "bob": 1, "fred": 2, "jon": 3, "gav": 4, "ian": 5,
        "abe": 6, "dan": 7, "ed": 8, "col": 9, "hal": 10},
    "bea": {
        "bob": 1, "abe": 2, "col": 3, "fred": 4, "gav": 5,
        "dan": 6, "ian": 7, "ed": 8, "jon": 9, "hal": 10},
    "cath": {
        "fred": 1, "bob": 2, "ed": 3, "gav": 4, "hal": 5,
        "col": 6, "ian": 7, "abe": 8, "dan": 9, "jon": 10},
    "dee": {
        "fred": 1, "jon": 2, "col": 3, "abe": 4, "ian": 5,
        "hal": 6, "gav": 7, "dan": 8, "bob": 9, "ed": 10},
    "eve": {
        "jon": 1, "hal": 2, "fred": 3, "dan": 4, "abe": 5,
        "gav": 6, "col": 7, "ed": 8, "ian": 9, "bob": 10},
    "fay": {
        "bob": 1, "abe": 2, "ed": 3, "ian": 4, "jon": 5,
        "dan": 6, "fred": 7, "gav": 8, "col": 9, "hal": 10},
    "gay": {
        "jon": 1, "gav": 2, "hal": 3, "fred": 4, "bob": 5,
        "abe": 6, "col": 7, "ed": 8, "dan": 9, "ian": 10},
    "hope": {
        "gav": 1, "jon": 2, "bob": 3, "abe": 4, "ian": 5,
        "dan": 6, "hal": 7, "ed": 8, "col": 9, "fred": 10},
    "ivy": {
        "ian": 1, "col": 2, "hal": 3, "gav": 4, "fred": 5,
        "bob": 6, "abe": 7, "ed": 8, "jon": 9, "dan": 10},
    "jan": {
        "ed": 1, "hal": 2, "gav": 3, "abe": 4, "bob": 5,
        "jon": 6, "col": 7, "ian": 8, "fred": 9, "dan": 10}
}

// Pair implements the Gale/Shapely algorithm.
var pair = Fn.new { |pPref, rPref|
    // code is destructive on the maps, so work with copies
    var pFree = {}
    for (me in pPref) pFree[me.key] = me.value
    var rFree = {}
    for (me in rPref) rFree[me.key] = me.value
    // struct only used in this function.
    // preferences must be saved in case engagement is broken.
    var Save = Struct.create("Save", ["proposer", "pPref", "rPref"])
    var proposals = {} // key is recipient (w)

    // WP pseudocode comments prefaced with WP: m is proposer, w is recipient.
    // WP: while ∃ free man m who still has a woman w to propose to
    while (pFree.count > 0) { // while there is a free proposer,
        var proposer
        var ppref
        for (me in pFree) {
            proposer = me.key
            ppref = me.value
            break // pick a proposer at random, whatever map iteration delivers first.
        }
        if (ppref.count == 0) continue // if proposer has no possible recipients, skip
        // WP: w = m's highest ranked such woman to whom he has not yet proposed
        var recipient = ppref[0] // highest ranged is first in list.
        ppref = ppref[1..-1]     // pop from list
        var rpref = {}
        // WP: if w is free
        if (rpref = rFree[recipient]) {
            // WP: (m, w) become engaged
            // (common code follows if statement)
        } else {
            // WP: else some pair (m', w) already exists
            var s = proposals[recipient] // get proposal saved preferences
            // WP: if w prefers m to m'
            if (s.rPref[proposer] < s.rPref[s.proposer]) {
                System.print("engagement broken: %(recipient) %(s.proposer)")
                // WP: m' becomes free
                pFree[s.proposer] = s.pPref // return proposer to the map
                // WP: (m, w) become engaged
                rpref = s.rPref
                // (common code follows if statement)
            } else {
                // WP: else (m', w) remain engaged
                pFree[proposer] = ppref // update preferences in map
                continue
            }
        }
        System.print("engagement: %(recipient) %(proposer)")
        proposals[recipient] = Save.new(proposer, ppref, rpref)
        pFree.remove(proposer)
        rFree.remove(recipient)
    }
    // construct return value
    var ps = {}
    for (me in proposals) {
        ps[me.key] = me.value.proposer
    }
    return ps
}

var validateStable = Fn.new { |ps, pPref, rPref|
    for (me in ps) System.print("%(me.key) %(me.value)")
    for (me in ps) {
        var r = me.key
        var p = me.value
        for (rp in pPref[p]) {
            if (rp == r) break
            var rprefs = rPref[rp]
            if (rprefs[p] < rprefs[ps[rp]]) {
                System.print("unstable.")
                System.print("%(p) and %(rp) would prefer each other over their current pairings.")
                return false
            }
        }
    }
    System.print("stable.")
    return true
}

// get parings by Gale/Shapley algorithm
var ps  = pair.call(mPref, wPref)
// show results
System.print("\nresult:")
if (!validateStable.call(ps, mPref, wPref)) return
// perturb
while (true) {
    var i = 0
    var w2 = List.filled(2, null)
    var m2 = List.filled(2, null)
    for (me in ps) {
        w2[i] = me.key
        m2[i] = me.value
        if (i == 1) break
        i = i + 1
    }
    System.print("\nexchanging partners of %(m2[0]) and %(m2[1])")
    ps[w2[0]] = m2[1]
    ps[w2[1]] = m2[0]
    // validate perturbed parings
    if (!validateStable.call(ps, mPref, wPref)) return
    // if those happened to be stable as well, perturb more
}
