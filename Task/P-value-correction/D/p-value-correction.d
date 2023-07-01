import std.algorithm;
import std.conv;
import std.math;
import std.stdio;
import std.string;

int[] seqLen(int start, int end) {
    int[] result;
    if (start == end) {
        result.length = end+1;
        for (int i; i<result.length; i++) {
            result[i] = i+1;
        }
    } else if (start < end) {
        result.length = end - start + 1;
        for (int i; i<result.length; i++) {
            result[i] = start+i;
        }
    } else {
        result.length = start - end + 1;
        for (int i; i<result.length; i++) {
            result[i] = start-i;
        }
    }
    return result;
}

int[] order(double[] array, bool decreasing) {
    int size = array.length;
    int[] idx;
    idx.length = size;
    double[] baseArr;
    baseArr.length = size;
    for (int i; i<size; i++) {
        baseArr[i] = array[i];
        idx[i] = i;
    }
    if (!decreasing) {
        alias comp = (a,b) => baseArr[a] < baseArr[b];
        idx.sort!comp;
    } else {
        alias comp = (a,b) => baseArr[b] < baseArr[a];
        idx.sort!comp;
    }
    return idx;
}

double[] cummin(double[] array) {
    int size = array.length;
    if (size < 1) throw new Exception("cummin requires at least one element");
    double[] output;
    output.length = size;
    auto cumulativeMin = array[0];
    foreach (i; 0..size) {
        if (array[i] < cumulativeMin) cumulativeMin = array[i];
        output[i] = cumulativeMin;
    }
    return output;
}

double[] cummax(double[] array) {
    auto size = array.length;
    if (size < 1) throw new Exception("cummax requires at least one element");
    double[] output;
    output.length = size;
    auto cumulativeMax = array[0];
    foreach (i; 0..size) {
        if (array[i] > cumulativeMax) cumulativeMax = array[i];
        output[i] = cumulativeMax;
    }
    return output;
}

double[] pminx(double[] array, double x) {
    auto size = array.length;
    if (size < 1) throw new Exception("pmin requires at least one element");
    double[] result;
    result.length = size;
    foreach (i; 0..size) {
        if (array[i] < x) {
            result[i] = array[i];
        } else {
            result[i] = x;
        }
    }
    return result;
}

void doubleSay(double[] array) {
    writef("[ 1] %e", array[0]);
    foreach (i; 1..array.length) {
        writef(" %.10f", array[i]);
        if ((i+1) % 5 == 0) writef("\n[%2d]", i+1);
    }
    writeln;
}

auto toArray(T,U)(U[] array) {
    T[] result;
    result.length = array.length;
    foreach(i; 0..array.length) {
        result[i] = to!T(array[i]);
    }
    return result;
}

double[] pAdjust(double[] pvalues, string str) {
    auto size = pvalues.length;
    if (size < 1) throw new Exception("pAdjust requires at least one element");
    int type = str.toLower.predSwitch!"a==b"(
        "bh",         0,
        "fdr",        0,
        "by",         1,
        "bonferroni", 2,
        "hochberg",   3,
        "holm",       4,
        "hommel",     5,
        { throw new Exception(text("'",str,"' doesn't match any accepted FDR types")); }()
    );
    if (type == 2) {  // Bonferroni method
        double[] result;
        result.length = size;
        foreach (i; 0..size) {
            auto b = pvalues[i] * size;
            if (b >= 1) {
                result[i] = 1;
            } else if (0 <= b && b < 1) {
                result[i] = b;
            } else {
                throw new Exception(text(b," is outside [0, 1)"));
            }
        }
        return result;
    } else if (type == 4) {  // Holm method
        auto o = order(pvalues, false);
        auto o2Double = toArray!(double,int)(o);
        double[] cummaxInput;
        cummaxInput.length = size;
        foreach (i; 0..size) {
            cummaxInput[i] = (size-i) * pvalues[o[i]];
        }
        auto ro = order(o2Double, false);
        auto cummaxOutput = cummax(cummaxInput);
        auto pmin = pminx(cummaxOutput, 1.0);
        double[] result;
        result.length = size;
        foreach (i; 0..size) {
            result[i] = pmin[ro[i]];
        }
        return result;
    } else if (type == 5) {
        auto indices = seqLen(size, size);
        auto o = order(pvalues, false);
        double[] p;
        p.length = size;
        foreach (i; 0..size) {
            p[i] = pvalues[o[i]];
        }
        auto o2Double = toArray!double(o);
        auto ro = order(o2Double, false);
        double[] q;
        q.length = size;
        double[] pa;
        pa.length = size;
        double[] npi;
        npi.length = size;
        foreach (i; 0..size) {
            npi[i] = p[i] * size / indices[i];
        }
        auto min_ = reduce!min(npi);
        q[] = min_;
        pa[] = min_;
        foreach_reverse (j; 2..size) {
            auto ij = seqLen(1, size - j + 1);
            foreach (i; 0..size-j+1) {
                ij[i]--;
            }
            auto i2Length = j-1;
            int[] i2;
            i2.length = i2Length;
            foreach(i; 0..i2Length) {
                i2[i] = size-j+2+i-1;
            }
            auto pi2Length = i2Length;
            double q1 = j*p[i2[0]] / 2.0;
            foreach (i; 1..pi2Length) {
                auto temp_q1 = p[i2[i]] * j / (2.0 + i);
                if (temp_q1 < q1) q1 = temp_q1;
            }
            foreach (i; 0..size-j+1) {
                q[ij[i]] = min(p[ij[i]] * j, q1);
            }
            foreach(i; 0..i2Length) {
                q[i2[i]] = q[size-j];
            }
            foreach(i; 0..size) if (pa[i] < q[i]) pa[i] = q[i];
        }
        foreach (index; 0..size) {
            q[index] = pa[ro[index]];
        }
        return q;
    }

    double[] ni;
    ni.length = size;
    auto o = order(pvalues, true);
    auto oDouble = toArray!double(o);
    foreach (index; 0..size) {
        if (pvalues[index] < 0 || pvalues[index] > 1) {
            throw new Exception(text("array[", index, "] = ", pvalues[index], " is outside [0, 1]"));
        }
        ni[index] = cast(double) size / (size - index);
    }
    auto ro = order(oDouble, false);
    double[] cumminInput;
    cumminInput.length = size;
    if (type == 0) {  // BH method
        foreach (index; 0..size) {
            cumminInput[index] = ni[index] * pvalues[o[index]];
        }
    } else if (type == 1) {  // BY method
        double q = 0;
        foreach (index; 1..size+1) q += 1.0 / index;
        foreach (index; 0..size) {
            cumminInput[index] = q * ni[index] * pvalues[o[index]];
        }
    } else if (type == 3) {  // Hochberg method
        foreach (index; 0..size) {
            cumminInput[index] = (index + 1) * pvalues[o[index]];
        }
    }
    auto cumminArray  =cummin(cumminInput);
    auto pmin = pminx(cumminArray, 1.0);
    double[] result;
    result.length = size;
    foreach (i; 0..size) {
        result[i] = pmin[ro[i]];
    }
    return result;
}

void main() {
    double[] pvalues = [
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
    ];

    double[][] correctAnswers = [
        [  // Benjamini-Hochberg
            6.126681e-01, 8.521710e-01, 1.987205e-01, 1.891595e-01, 3.217789e-01,
            9.301450e-01, 4.870370e-01, 9.301450e-01, 6.049731e-01, 6.826753e-01,
            6.482629e-01, 7.253722e-01, 5.280973e-01, 8.769926e-01, 4.705703e-01,
            9.241867e-01, 6.049731e-01, 7.856107e-01, 4.887526e-01, 1.136717e-01,
            4.991891e-01, 8.769926e-01, 9.991834e-01, 3.217789e-01, 9.301450e-01,
            2.304958e-01, 5.832475e-01, 3.899547e-02, 8.521710e-01, 1.476843e-01,
            1.683638e-02, 2.562902e-03, 3.516084e-02, 6.250189e-02, 3.636589e-03,
            2.562902e-03, 2.946883e-02, 6.166064e-03, 3.899547e-02, 2.688991e-03,
            4.502862e-04, 1.252228e-05, 7.881555e-02, 3.142613e-02, 4.846527e-03,
            2.562902e-03, 4.846527e-03, 1.101708e-03, 7.252032e-02, 2.205958e-02
        ],
        [  // Benjamini & Yekutieli
            1.000000e+00, 1.000000e+00, 8.940844e-01, 8.510676e-01, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 5.114323e-01,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.754486e-01, 1.000000e+00, 6.644618e-01,
            7.575031e-02, 1.153102e-02, 1.581959e-01, 2.812089e-01, 1.636176e-02,
            1.153102e-02, 1.325863e-01, 2.774239e-02, 1.754486e-01, 1.209832e-02,
            2.025930e-03, 5.634031e-05, 3.546073e-01, 1.413926e-01, 2.180552e-02,
            1.153102e-02, 2.180552e-02, 4.956812e-03, 3.262838e-01, 9.925057e-02
        ],
        [  // Bonferroni
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 7.019185e-01, 1.000000e+00, 1.000000e+00,
            2.020365e-01, 1.516674e-02, 5.625735e-01, 1.000000e+00, 2.909271e-02,
            1.537741e-02, 4.125636e-01, 6.782670e-02, 6.803480e-01, 1.882294e-02,
            9.005725e-04, 1.252228e-05, 1.000000e+00, 4.713920e-01, 4.395577e-02,
            1.088915e-02, 4.846527e-02, 3.305125e-03, 1.000000e+00, 2.867745e-01
        ],
        [  // Hochberg
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 4.632662e-01, 9.991834e-01, 9.991834e-01,
            1.575885e-01, 1.383967e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
            1.383967e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
            8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
            1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
        ],
        [  // Holm
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 4.632662e-01, 1.000000e+00, 1.000000e+00,
            1.575885e-01, 1.395341e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
            1.395341e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
            8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
            1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
        ],
        [   // Hommel
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.987624e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.595180e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 4.351895e-01, 9.991834e-01, 9.766522e-01,
            1.414256e-01, 1.304340e-02, 3.530937e-01, 6.887709e-01, 2.385602e-02,
            1.322457e-02, 2.722920e-01, 5.426136e-02, 4.218158e-01, 1.581127e-02,
            8.825610e-04, 1.252228e-05, 8.743649e-01, 3.016908e-01, 3.516461e-02,
            9.582456e-03, 3.877222e-02, 3.172920e-03, 8.122276e-01, 1.950067e-01
        ]
    ];
    auto types = ["bh", "by", "bonferroni", "hochberg", "holm", "hommel"];
    foreach (type; 0..types.length) {
        auto q = pAdjust(pvalues, types[type]);
        double error = 0.0;
        foreach (i; 0..pvalues.length) {
            error += abs(q[i] - correctAnswers[type][i]);
        }
        doubleSay(q);
        writefln("\ntype %d = '%s' has a cumulative error of %g", type, types[type], error);
    }
}
