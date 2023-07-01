import std.algorithm;
import std.array;
import std.exception;
import std.range;
import std.stdio;

public class Matrix {
    private double[][] data;
    private size_t rowCount;
    private size_t colCount;

    public this(size_t size)
    in(size > 0, "Must have at least one element")
    {
        this(size, size);
    }

    public this(size_t rows, size_t cols)
    in(rows > 0, "Must have at least one row")
    in(cols > 0, "Must have at least one column")
    {
        rowCount = rows;
        colCount = cols;

        data = uninitializedArray!(double[][])(rows, cols);
        foreach (ref row; data) {
            row[] = 0.0;
        }
    }

    public this(const double[][] source) {
        enforce(source.length > 0, "Must have at least one row");
        rowCount = source.length;

        enforce(source[0].length > 0, "Must have at least one column");
        colCount = source[0].length;

        data = uninitializedArray!(double[][])(rowCount, colCount);
        foreach (i; 0 .. rowCount) {
            enforce(source[i].length == colCount, "All rows must have equal columns");
            data[i] = source[i].dup;
        }
    }

    public auto opIndex(size_t r, size_t c) const {
        return data[r][c];
    }

    public auto opIndex(size_t r) const {
        return data[r];
    }

    public auto opBinary(string op)(const Matrix rhs) const {
        static if (op == "*") {
            auto rc1 = rowCount;
            auto cc1 = colCount;
            auto rc2 = rhs.rowCount;
            auto cc2 = rhs.colCount;
            enforce(cc1 == rc2, "Cannot multiply if the first columns does not equal the second rows");
            auto result = new Matrix(rc1, cc2);
            foreach (i; 0 .. rc1) {
                foreach (j; 0 .. cc2) {
                    foreach (k; 0 .. rc2) {
                        result[i, j] += this[i, k] * rhs[k, j];
                    }
                }
            }
            return result;
        } else {
            assert(false, "Not implemented");
        }
    }

    public void opIndexAssign(double value, size_t r, size_t c) {
        data[r][c] = value;
    }

    public void opIndexAssign(const double[] value, size_t r) {
        enforce(colCount == value.length, "Slice size must match column size");
        data[r] = value.dup;
    }

    public void opIndexOpAssign(string op)(double value, size_t r, size_t c) {
        mixin("data[r][c] " ~ op ~ "= value;");
    }

    public auto transpose() const {
        auto rc = rowCount;
        auto cc = colCount;
        auto t = new Matrix(cc, rc);
        foreach (i; 0 .. cc) {
            foreach (j; 0 .. rc) {
                t[i, j] = this[j, i];
            }
        }
        return t;
    }

    public void toReducedRowEchelonForm() {
        auto lead = 0;
        auto rc = rowCount;
        auto cc = colCount;
        foreach (r; 0 .. rc) {
            if (cc <= lead) {
                return;
            }
            auto i = r;

            while (this[i, lead] == 0.0) {
                i++;
                if (rc == i) {
                    i = r;
                    lead++;
                    if (cc == lead) {
                        return;
                    }
                }
            }

            auto temp = this[i];
            this[i] = this[r];
            this[r] = temp;

            if (this[r, lead] != 0.0) {
                auto div = this[r, lead];
                foreach (j; 0 .. cc) {
                    this[r, j] = this[r, j] / div;
                }
            }

            foreach (k; 0 .. rc) {
                if (k != r) {
                    auto mult = this[k, lead];
                    foreach (j; 0 .. cc) {
                        this[k, j] -= this[r, j] * mult;
                    }
                }
            }

            lead++;
        }
    }

    public auto inverse() const {
        enforce(rowCount == colCount, "Not a square matrix");
        auto len = rowCount;
        auto aug = new Matrix(len, 2 * len);
        foreach (i; 0 .. len) {
            foreach (j; 0 .. len) {
                aug[i, j] = this[i, j];
            }
            // augment identity matrix to right
            aug[i, i + len] = 1.0;
        }
        aug.toReducedRowEchelonForm;
        auto inv = new Matrix(len);
        // remove identify matrix to left
        foreach (i; 0 .. len) {
            foreach (j; len .. 2 * len) {
                inv[i, j - len] = aug[i, j];
            }
        }
        return inv;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        auto fmt = FormatSpec!char("%s");

        put(sink, "[");
        foreach (i; 0 .. rowCount) {
            if (i > 0) {
                put(sink, " [");
            } else {
                put(sink, "[");
            }

            formatValue(sink, this[i, 0], fmt);
            foreach (j; 1 .. colCount) {
                put(sink, ", ");
                formatValue(sink, this[i, j], fmt);
            }

            if (i + 1 < rowCount) {
                put(sink, "]\n");
            } else {
                put(sink, "]");
            }
        }
        put(sink, "]");
    }
}

auto multipleRegression(double[] y, Matrix x) {
    auto tm = new Matrix([y]);
    auto cy = tm.transpose;
    auto cx = x.transpose;
    return ((x * cx).inverse * x * cy).transpose[0].dup;
}

void main() {
    auto y = [1.0, 2.0, 3.0, 4.0, 5.0];
    auto x = new Matrix([[2.0, 1.0, 3.0, 4.0, 5.0]]);
    auto v = multipleRegression(y, x);
    v.writeln;

    y = [3.0, 4.0, 5.0];
    x = new Matrix([
        [1.0, 2.0, 1.0],
        [1.0, 1.0, 2.0]
    ]);
    v = multipleRegression(y, x);
    v.writeln;

    y = [52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46];
    auto a = [1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83];
    x = new Matrix([
        repeat(1.0, a.length).array,
        a,
        a.map!"a * a".array
    ]);
    v = multipleRegression(y, x);
    v.writeln;
}
