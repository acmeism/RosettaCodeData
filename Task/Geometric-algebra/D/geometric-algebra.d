import std.exception;
import std.random;
import std.stdio;

auto doubleArray(size_t size) {
    double[] result;
    result.length = size;
    result[] = 0.0;
    return result;
}

int bitCount(int i) {
    i -= ((i >> 1) & 0x55555555);
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
    i = (i + (i >> 4)) & 0x0F0F0F0F;
    i += (i >> 8);
    i += (i >> 16);
    return i & 0x0000003F;
}

double reorderingSign(int i, int j) {
    int k = i >> 1;
    int sum = 0;
    while (k != 0) {
        sum += bitCount(k & j);
        k = k >> 1;
    }
    return ((sum & 1) == 0) ? 1.0 : -1.0;
}

struct Vector {
    private double[] dims;

    this(double[] da) {
        dims = da;
    }

    Vector dot(Vector rhs) {
        return (this * rhs + rhs * this) * 0.5;
    }

    Vector opUnary(string op : "-")() {
        return this * -1.0;
    }

    Vector opBinary(string op)(Vector rhs) {
        import std.algorithm.mutation : copy;
        static if (op == "+") {
            auto result = doubleArray(32);
            copy(dims, result);
            foreach (i; 0..rhs.dims.length) {
                result[i] += rhs[i];
            }
            return Vector(result);
        } else if (op == "*") {
            auto result = doubleArray(32);
            foreach (i; 0..dims.length) {
                if (dims[i] != 0.0) {
                    foreach (j; 0..dims.length) {
                        if (rhs[j] != 0.0) {
                            auto s = reorderingSign(i, j) * dims[i] * rhs[j];
                            auto k = i ^ j;
                            result[k] += s;
                        }
                    }
                }
            }
            return Vector(result);
        } else {
            assert(false);
        }
    }

    Vector opBinary(string op : "*")(double scale) {
        auto result = dims.dup;
        foreach (i; 0..5) {
            dims[i] = dims[i] * scale;
        }
        return Vector(result);
    }

    double opIndex(size_t i) {
        return dims[i];
    }

    void opIndexAssign(double value, size_t i) {
        dims[i] = value;
    }
}

Vector e(int n) {
    enforce(n <= 4, "n must be less than 5");

    auto result = Vector(doubleArray(32));
    result[1 << n] = 1.0;
    return result;
}

Vector randomVector() {
    auto result = Vector(doubleArray(32));
    foreach (i; 0..5) {
        result = result + Vector([uniform01()]) * e(i);
    }
    return result;
}

Vector randomMultiVector() {
    auto result = Vector(doubleArray(32));
    foreach (i; 0..32) {
        result[i] = uniform01();
    }
    return result;
}

void main() {
    foreach (i; 0..5) {
        foreach (j; 0..5) {
            if (i < j) {
                if ((e(i).dot(e(j)))[0] != 0.0) {
                    writeln("Unexpected non-null scalar product.");
                    return;
                } else if (i == j) {
                    if ((e(i).dot(e(j)))[0] == 0.0) {
                        writeln("Unexpected null scalar product.");
                    }
                }
            }
        }
    }

    auto a = randomMultiVector();
    auto b = randomMultiVector();
    auto c = randomMultiVector();
    auto x = randomVector();

    // (ab)c == a(bc)
    writeln((a * b) * c);
    writeln(a * (b * c));
    writeln;

    // a(b+c) == ab + ac
    writeln(a * (b + c));
    writeln(a * b + a * c);
    writeln;

    // (a+b)c == ac + bc
    writeln((a + b) * c);
    writeln(a * c + b * c);
    writeln;

    // x^2 is real
    writeln(x * x);
}
