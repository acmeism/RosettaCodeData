import "./dynamic" for Struct
import "./ioutil" for FileUtil, File
import "./math" for Nums
import "./seq" for Lst
import "./fmt" for Fmt

var Shipment = Struct.create("Shipment", ["quantity", "costPerUnit", "r", "c"])

class Transport {
    construct new(filename) {
        var lines = FileUtil.readLines(filename)
        var split = lines[0].split(" ")
        var numSources = Num.fromString(split[0])
        var numDests   = Num.fromString(split[1])
        var src = List.filled(numSources, 0)
        var dst = List.filled(numDests, 0)
        split = lines[1].split(" ")
        for (i in 0...numSources) src[i] = Num.fromString(split[i])
        split = lines[2].split(" ")
        for (i in 0...numDests) dst[i] = Num.fromString(split[i])

        // fix imbalance
        var totalSrc = Nums.sum(src)
        var totalDst = Nums.sum(dst)
        if (totalSrc > totalDst) {
            dst.add(totalSrc - totalDst)
        } else if (totalDst > totalSrc) {
            src.add(totalDst - totalSrc)
        }
        _supply = src
        _demand = dst
        _costs  = List.filled(_supply.count, null)
        _matrix = List.filled(_supply.count, null)
        for (i in 0..._supply.count) {
            _costs[i]  = List.filled(_demand.count, 0)
            _matrix[i] = List.filled(_demand.count, null)
        }
        for (i in 0...numSources) {
            split = lines[i + 3].split(" ")
            for (j in 0...numDests) _costs[i][j] = Num.fromString(split[j])
        }
        _filename = filename
    }

    northWestCornerRule() {
        var northwest = 0
        for (r in 0..._supply.count) {
            var c = northwest
            while (c < _demand.count) {
                var quantity = _supply[r].min(_demand[c])
                if (quantity > 0) {
                    _matrix[r][c] = Shipment.new(quantity, _costs[r][c], r, c)
                    _supply[r] = _supply[r] - quantity.floor
                    _demand[c] = _demand[c] - quantity.floor
                    if (_supply[r] == 0) {
                        northwest = c
                        break
                    }
                }
                c = c + 1
            }
        }
    }

    steppingStone() {
        var maxReduction = 0
        var move = null
        var leaving = null
        fixDegenerateCase_()

        for (r in 0..._supply.count) {
            for (c in 0..._demand.count) {
                if (_matrix[r][c] != null) continue
                var trial = Shipment.new(0, _costs[r][c], r, c)
                var path = getClosedPath_(trial)
                var reduction = 0
                var lowestQuantity = Num.maxSafeInteger
                var leavingCandidate = null
                var plus = true
                for (s in path) {
                    if (plus) {
                        reduction = reduction + s.costPerUnit
                    } else {
                        reduction = reduction - s.costPerUnit
                        if (s.quantity < lowestQuantity) {
                            leavingCandidate = s
                            lowestQuantity = s.quantity
                        }
                    }
                    plus = !plus
                }
                if (reduction < maxReduction) {
                    move = path
                    leaving = leavingCandidate
                    maxReduction = reduction
                }
            }
        }

        if (move) {
            var q = leaving.quantity
            var plus = true
            for (s in move) {
                s.quantity = s.quantity + ((plus) ? q : -q)
                _matrix[s.r][s.c] = (s.quantity == 0) ? null : s
                plus = !plus
            }
            steppingStone()
        }
    }

    matrixToList_() { Lst.flatten(_matrix).where { |s| s != null }.toList }

    getClosedPath_(s) {
        var path = matrixToList_()
        path.insert(0, s)
        // remove (and keep removing) elements that do not have a
        // vertical AND horizontal neighbor
        while (true) {
            var removals = 0
            for (e in path) {
                var nbrs = getNeighbors_(e, path)
                if (nbrs[0] == null || nbrs[1] == null) {
                    path.remove(e)
                    removals = removals + 1
                }
            }
            if (removals == 0) break
        }

        // place the remaining elements in the correct plus-minus order
        var stones = List.filled(path.count, null)
        var prev = s
        for (i in 0...stones.count) {
            stones[i] = prev
            prev = getNeighbors_(prev, path)[i % 2]
        }
        return stones
    }

    getNeighbors_(s, lst) {
        var nbrs = List.filled(2, null)
        for (o in lst) {
            if (o != s) {
                if (o.r == s.r && nbrs[0] == null) {
                    nbrs[0] = o
                } else if (o.c == s.c && nbrs[1] == null) {
                    nbrs[1] = o
                }
                if (nbrs[0] != null && nbrs[1] != null) break
            }
        }
        return nbrs
    }

    fixDegenerateCase_() {
        var eps = Num.smallest
        if (_supply.count + _demand.count - 1 != matrixToList_().count) {
            for (r in 0..._supply.count) {
                for (c in 0..._demand.count) {
                    if (_matrix[r][c] == null) {
                        var dummy = Shipment.new(eps, _costs[r][c], r, c)
                        if (getClosedPath_(dummy).count == 0) {
                            _matrix[r][c] = dummy
                            return
                        }
                    }
                }
            }
        }
    }

    printResult() {
        var text = File.read(_filename)
        System.print("%(_filename)\n\n%(text)")
        System.print("Optimal solution %(_filename)\n")
        var totalCosts = 0
        for (r in 0..._supply.count) {
            for (c in 0..._demand.count) {
                var s = _matrix[r][c]
                if (s != null && s.r == r && s.c == c) {
                    Fmt.write(" $3d ", s.quantity.floor)
                    totalCosts = totalCosts + s.quantity * s.costPerUnit
                } else System.write("  -  ")
            }
            System.print()
        }
        System.print("\nTotal costs: %(totalCosts)\n")
    }
}

var filenames = ["input1.txt", "input2.txt", "input3.txt"]
for (filename in filenames) {
    var t = Transport.new(filename)
    t.northWestCornerRule()
    t.steppingStone()
    t.printResult()
}
