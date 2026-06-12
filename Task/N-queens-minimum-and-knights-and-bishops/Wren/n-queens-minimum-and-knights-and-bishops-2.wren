import "./linear" for Prob, Glp, Tran, File
import "./fmt" for Fmt

var start = System.clock

var queenMpl = """
var x{1..n, 1..n}, binary;
s.t. a{i in 1..n}: sum{j in 1..n} x[i,j] <= 1;
s.t. b{j in 1..n}: sum{i in 1..n} x[i,j] <= 1;
s.t. c{k in 2-n..n-2}: sum{i in 1..n, j in 1..n: i-j == k} x[i,j] <= 1;
s.t. d{k in 3..n+n-1}: sum{i in 1..n, j in 1..n: i+j == k} x[i,j] <= 1;
s.t. e{i in 1..n, j in 1..n}:
    sum{k in 1..n} x[i,k] +
    sum{k in 1..n} x[k,j] +
    sum{k in (1-n)..n: 1 <= i + k && i + k <= n && 1 <= j + k && j + k <=n} x[i+k,j+k]  +
    sum{k in (1-n)..n: 1 <= i - k && i - k <= n && 1 <= j + k && j + k <=n} x[i-k, k+j] >= 1;

minimize obj: sum{i in 1..n, j in 1..n} x[i,j];
solve;
end;

"""

var bishopMpl = """
var x{1..n, 1..n}, binary;
s.t. a{k in 2-n..n-2}: sum{i in 1..n, j in 1..n: i-j == k} x[i,j] <= 1;
s.t. b{k in 3..n+n-1}: sum{i in 1..n, j in 1..n: i+j == k} x[i,j] <= 1;
s.t. c{i in 1..n, j in 1..n}:
    sum{k in (1-n)..n: 1 <= i + k && i + k <= n && 1 <= j + k && j + k <=n} x[i+k,j+k]  +
    sum{k in (1-n)..n: 1 <= i - k && i - k <= n && 1 <= j + k && j + k <=n} x[i-k, k+j] >= 1;

minimize obj: sum{i in 1..n, j in 1..n} x[i,j];
solve;
end;

"""

var knightMpl = """
set deltas, dimen 2;
var x{1..n+4, 1..n+4}, binary;
s.t. a{i in 1..n+4}: sum{j in 1..n+4: j < 3 || j > n + 2} x[i,j] = 0;
s.t. b{j in 1..n+4}: sum{i in 1..n+4: i < 3 || i > n + 2} x[i,j] = 0;
s.t. c{i in 3..n+2, j in 3..n+2}: x[i, j] + sum{(k, l) in deltas} x[i + k, j + l] >= 1;
s.t. d{i in 3..n+2, j in 3..n+2}: sum{(k, l) in deltas} x[i + k, j + l] + 100 * x[i, j] <= 100;

minimize obj: sum{i in 3..n+2, j in 3..n+2} x[i,j];
solve;
data;
set deltas := (1,2) (2,1) (2,-1) (1,-2) (-1,-2) (-2,-1) (-2,1) (-1,2);
end;

"""

var mpls   = {"Q": queenMpl, "B": bishopMpl, "K": knightMpl}
var pieces = ["Q", "B", "K"]
var limits = {"Q": 10, "B": 10, "K": 10}
var names  = {"Q": "Queens", "B": "Bishops", "K": "Knights"}
var fname  = "n_pieces.mod"

Glp.termOut(Glp.OFF)
for (piece in pieces) {
    System.print(names[piece])
    System.print("=======\n")
    for (n in 1..limits[piece]) {
        var first = "param n, integer, > 0, default %(n);\n"
        File.write(fname, first + mpls[piece])
        var mip = Prob.create()
        var tran = Tran.mplAllocWksp()
        var ret = tran.mplReadModel(fname, 0)
        if (ret != 0) System.print("Error on translating model.")
        if (ret == 0) {
            ret = tran.mplGenerate(null)
            if (ret != 0) System.print("Error on generating model.")
            if (ret == 0) {
                tran.mplBuildProb(mip)
                mip.simplex(null)
                mip.intOpt(null)
                Fmt.print("$2d x $-2d : $d", n, n, mip.mipObjVal.round)
                if (n == limits[piece]) {
                    Fmt.print("\n$s on a $d x $d board:\n", names[piece], n, n)
                    var cols = {}
                    if (piece != "K") {
                        for (i in 1..n*n) cols[mip.colName(i)] = mip.mipColVal(i)
                        for (i in 1..n) {
                            for (j in 1..n) {
                                var char = (cols["x[%(i),%(j)]"] == 1) ? "%(piece) " : ". "
                                System.write(char)
                            }
                            System.print()
                        }
                    } else {
                        for (i in 1..(n+4)*(n+4)) cols[mip.colName(i)] = mip.mipColVal(i)
                        for (i in 3..n+2) {
                            for (j in 3..n+2) {
                                var char = (cols["x[%(i),%(j)]"] == 1) ? "%(piece) " : ". "
                                System.write(char)
                            }
                            System.print()
                        }
                    }
                }
            }
        }
        tran.mplFreeWksp()
        mip.delete()
    }
    System.print()
}
File.remove(fname)
System.print("Took %(System.clock - start) seconds.")
