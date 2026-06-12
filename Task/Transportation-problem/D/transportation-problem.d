import std.stdio, std.range, std.algorithm, std.conv, std.math, std.traits;

final class Shipment {
    double quantity;
    immutable double costPerUnit;
    immutable size_t r, c;

    this(in double q, in double cpu, in size_t r_, in size_t c_)
    pure nothrow @safe @nogc {
        quantity = q;
        costPerUnit = cpu;
        this.r = r_;
        this.c = c_;
    }
}

alias ShipmentMat = Shipment[][];
alias CostsMat = double[][];

void init(in string fileName, out uint[] demand, out uint[] supply,
          out CostsMat costs, out ShipmentMat matrix) {
    auto inParts = fileName.File.byLine.map!splitter.joiner;

    immutable numSources = inParts.front.to!uint;
    inParts.popFront;
    immutable numDestinations = inParts.front.to!uint;
    inParts.popFront;

    foreach (immutable i; 0 .. numSources) {
        supply ~= inParts.front.to!uint;
        inParts.popFront;
    }

    foreach (immutable i; 0 .. numDestinations) {
        demand ~= inParts.front.to!uint;
        inParts.popFront;
    }

    // Fix imbalance.
    immutable totalSrc = supply.sum;
    immutable totalDst = demand.sum;

    if (totalSrc > totalDst)
        demand ~= totalSrc - totalDst;
    else if (totalDst > totalSrc)
        supply ~= totalDst - totalSrc;

    costs = new CostsMat(supply.length, demand.length);
    foreach (row; costs)
        row[] = 0.0;
    matrix = new ShipmentMat(supply.length, demand.length);

    foreach (immutable i; 0 .. numSources)
        foreach (immutable j; 0 .. numDestinations) {
            costs[i][j] = inParts.front.to!double;
            inParts.popFront;
        }
}

void northWestCornerRule(uint[] demand, uint[] supply, in CostsMat costs,
                         ShipmentMat matrix) pure nothrow @safe {
    size_t northwest = 0;
    foreach (immutable r; 0 .. supply.length) {
        foreach (immutable c; northwest .. demand.length) {
            immutable quantity = min(supply[r], demand[c]);
            if (quantity > 0) {
                matrix[r][c] = new Shipment(quantity, costs[r][c], r, c);

                supply[r] -= quantity;
                demand[c] -= quantity;

                if (supply[r] == 0) {
                    northwest = c;
                    break;
                }
            }
        }
    }
}

void steppingStone(in uint[] demand, in uint[] supply,
                   in CostsMat costs, ShipmentMat matrix) pure @safe {
    double maxReduction = 0;
    Shipment[] move;
    Shipment leaving = null;

    fixDegenerateCase(demand, supply, costs, matrix);

    foreach (immutable r; 0 .. supply.length) {
        foreach (immutable c; 0 .. demand.length) {
            if (matrix[r][c] !is null)
                continue;

            auto trial = new Shipment(0, costs[r][c], r, c);
            auto path = getClosedPath(trial, matrix);

            double reduction = 0;
            double lowestQuantity = uint.max;
            Shipment leavingCandidate = null;

            bool plus = true;
            foreach (s; path) {
                if (plus) {
                    reduction += s.costPerUnit;
                } else {
                    reduction -= s.costPerUnit;
                    if (s.quantity < lowestQuantity) {
                        leavingCandidate = s;
                        lowestQuantity = s.quantity;
                    }
                }
                plus = !plus;
            }
            if (reduction < maxReduction) {
                move = path;
                leaving = leavingCandidate;
                maxReduction = reduction;
            }
        }
    }

    if (move !is null) {
        auto q = leaving.quantity;
        auto plus = true;
        foreach (s; move) {
            s.quantity += plus ? q : -q;
            matrix[s.r][s.c] = (s.quantity == 0) ? null : s;
            plus = !plus;
        }
        steppingStone(demand, supply, costs, matrix);
    }
}

auto matrixToSeq(ShipmentMat matrix) pure nothrow @nogc @safe {
    return matrix.joiner.filter!(s => s !is null);
}

Shipment[] getClosedPath(Shipment s, ShipmentMat matrix) pure @safe
in {
    assert(s !is null);
} out(result) {
    assert(result.all!(sh => sh !is null));
} body {
    Shipment[] stones = chain([s], matrixToSeq(matrix)).array;

    // Remove (and keep removing) elements that do not have
    // a vertical AND horizontal neighbor.
    while (true) {
        auto stones2 = stones.remove!((in e) {
            const nbrs = getNeighbors(e, stones);
            return nbrs[0] is null || nbrs[1] is null;
        });

        if (stones2.length == stones.length)
            break;
        stones = stones2;
    }

    // Place the remaining elements in the correct plus-minus order.
    auto stones3 = stones.dup;
    Shipment prev = s;
    foreach (immutable i, ref si; stones3) {
        si = prev;
        prev = getNeighbors(prev, stones)[i % 2];
    }
    return stones3;
}

Shipment[2] getNeighbors(ShipmentsRange)(in Shipment s, ShipmentsRange seq)
pure nothrow @safe @nogc
if (isForwardRange!ShipmentsRange && is(ForeachType!ShipmentsRange == Shipment))
in {
    assert(s !is null);
    assert(seq.all!(sh => sh !is null));
} body {
    Shipment[2] nbrs;

    foreach (o; seq) {
        if (o !is s) {
            if (o.r == s.r && nbrs[0] is null)
                nbrs[0] = o;
            else if (o.c == s.c && nbrs[1] is null)
                nbrs[1] = o;
            if (nbrs[0] !is null && nbrs[1] !is null)
                break;
        }
    }

    return nbrs;
}

void fixDegenerateCase(in uint[] demand, in uint[] supply,
                       in CostsMat costs, ShipmentMat matrix) pure @safe {
    immutable eps = double.min_normal;

    if (supply.length.signed + demand.length.signed - 1 != matrixToSeq(matrix).walkLength) {
        foreach (immutable r; 0 .. supply.length) {
            foreach (immutable c; 0 .. demand.length) {
                if (matrix[r][c] is null) {
                    auto dummy = new Shipment(eps, costs[r][c], r, c);
                    if (getClosedPath(dummy, matrix).length == 0) {
                        matrix[r][c] = dummy;
                        return;
                    }
                }
            }
        }
    }
}

void printResult(in string fileName, in uint[] demand, in uint[] supply,
                 in CostsMat costs, in ShipmentMat matrix) @safe /*@nogc*/ {
    writefln("Optimal solution %s", fileName);
    double totalCosts = 0;

    foreach (immutable r; 0 .. supply.length) {
        foreach (immutable c; 0 .. demand.length) {
            const s = matrix[r][c];
            if (s !is null && s.r == r && s.c == c) {
                writef(" %3d ", cast(uint)s.quantity);
                totalCosts += s.quantity * s.costPerUnit;
            } else
                write("  -  ");
        }
        //writeln; // Not @safe?
        write('\n');
    }
    writefln("\nTotal costs: %s\n", totalCosts);
}

void main() {
    foreach (fileName; ["transportation_problem1.txt",
                        "transportation_problem2.txt",
                        "transportation_problem3.txt"]) {
        uint[] demand, supply;
        CostsMat costs;
        ShipmentMat matrix;
        init(fileName, demand, supply, costs, matrix);
        northWestCornerRule(demand, supply, costs, matrix);
        steppingStone(demand, supply, costs, matrix);
        printResult(fileName, demand, supply, costs, matrix);
    }
}
