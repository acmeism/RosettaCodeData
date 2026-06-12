import "random" for Random
import "./math" for Nums

var Rand = Random.new()

var UNTREATED = 0
var IRREGULAR = 1
var REGULAR   = 2
var DOSE_FOR_REGULAR = 100

/* A subject for the study. */
class Subject {
    construct new() {
        _cumDose = 0
        _category = UNTREATED
        _hadCovid = false
        _updateCount = 0
    }

    cumDose     { _cumDose }
    category    { _category }
    hadCovid    { _hadCovid }
    updateCount { _updateCount }

    cumDose(d)     { _cumDose = d }
    category(c)    { _category = c }
    hadCovid(h)    { _hadCovid = h }
    updateCount(u) { _updateCount = u }

    // Daily update on the subject to check for infection and randomly dose.
    update(pCovid, pStartingTreatment, pRedose, dRange) {
        if (!_hadCovid) {
            if (Rand.float() < pCovid) {
                _hadCovid = true
            } else if ((_cumDose == 0 && Rand.float() < pStartingTreatment) ||
                       (_cumDose > 0 && Rand.float() < pRedose)) {
                _cumDose = _cumDose + Rand.sample(dRange)
                categorize()
            }
        }
        _updateCount = _updateCount + 1
    }

    // Update using default parameters.
    update() { update(0.001, 0.005, 0.25, [3, 6, 9]) }

    // Set treatment category based on cumulative treatment taken.
    categorize() {
        _category = (_cumDose == 0) ? UNTREATED :
                    (_cumDose >= DOSE_FOR_REGULAR) ? REGULAR : IRREGULAR
        return _category
    }
}

// a, b and c are assumed to be lists of boolean values.
var kruskal = Fn.new { |a, b, c|
    // map the bool values to 1 (true) or 0 (false).
    var aa = a.map { |e| e ? 1: 0 }.toList
    var bb = b.map { |e| e ? 1: 0 }.toList
    var cc = b.map { |e| e ? 1: 0 }.toList
    // aggregate and sort them
    var ss = (aa + bb + cc).sort()
    // find rank of first occurrence of 1
    var ix = ss.indexOf(1) + 1
    // calculate average ranks for 0 and 1
    var arf = (1 + ix - 1) / 2
    var n = ss.count
    var art = (ix + n) / 2
    // calculate sum of ranks for each list
    var sra = Nums.sum(a.map { |e| e ? art : arf })
    var srb = Nums.sum(b.map { |e| e ? art : arf })
    var src = Nums.sum(c.map { |e| e ? art : arf })
    // calculate H
    var H = 12/(n*(n+1)) * (sra*sra/a.count + srb*srb/b.count + src*src/c.count) - 3 * (n + 1)
    return H
}

// Run the study using the population of size 'N' for 'duration' days.
var runStudy = Fn.new { |numSubjects, duration, interval|
    var population = List.filled(numSubjects, null)
    for (i in 0...numSubjects) population[i] = Subject.new()
    var unt = 0
    var untCovid = 0
    var irr = 0
    var irrCovid = 0
    var reg = 0
    var regCovid = 0
    System.print("Total subjects: %(numSubjects)")
    for (day in 0...duration) {
        for (subj in population) subj.update()
        if ((day + 1) % interval == 0) {
            System.print("\nDay %(day + 1):")
            unt = population.count { |s| s.category == UNTREATED }
            untCovid = population.count { |s| s.category == UNTREATED && s.hadCovid }
            System.print("Untreated: N = %(unt), with infection = %(untCovid)")
            irr = population.count { |s| s.category == IRREGULAR }
            irrCovid = population.count { |s| s.category == IRREGULAR && s.hadCovid }
            reg = population.count { |s| s.category == REGULAR }
            regCovid = population.count { |s| s.category == REGULAR && s.hadCovid }
            System.print("Regular Use: N = %(reg), with infection = %(regCovid)")
        }
        if (day == (duration/2).floor - 1) {
            System.print("\nAt midpoint, Infection case percentages are:")
            System.print("  Untreated : %(100 * untCovid / unt)")
            System.print("  Irregulars: %(100 * irrCovid / irr)")
            System.print("  Regulars  : %(100 * regCovid / reg)")
        }
    }
    System.print("\nAt study end, Infection case percentages are:")
    System.print("  Untreated : %(100 * untCovid / unt) of group size of %(unt)")
    System.print("  Irregulars: %(100 * irrCovid / irr) of group size of %(irr)")
    System.print("  Regulars  : %(100 * regCovid / reg) of group size of %(reg)")
    var untreated = population.where { |s| s.category == UNTREATED }.map { |s| s.hadCovid }.toList
    var irregular = population.where { |s| s.category == IRREGULAR }.map { |s| s.hadCovid }.toList
    var regular   = population.where { |s| s.category == REGULAR   }.map { |s| s.hadCovid }.toList
    System.print("\nFinal statistics: H = %(kruskal.call(untreated, irregular, regular))")
}

runStudy.call(1000, 180, 30)
