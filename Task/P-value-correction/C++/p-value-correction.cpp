#include <algorithm>
#include <functional>
#include <iostream>
#include <numeric>
#include <vector>

std::vector<int> seqLen(int start, int end) {
    std::vector<int> result;

    if (start == end) {
        result.resize(end + 1);
        std::iota(result.begin(), result.end(), 1);
    } else if (start < end) {
        result.resize(end - start + 1);
        std::iota(result.begin(), result.end(), start);
    } else {
        result.resize(start - end + 1);
        std::iota(result.rbegin(), result.rend(), end);
    }

    return result;
}

std::vector<int> order(const std::vector<double>& arr, bool decreasing) {
    std::vector<int> idx(arr.size());
    std::iota(idx.begin(), idx.end(), 0);

    std::function<bool(int, int)> cmp;
    if (decreasing) {
        cmp = [&arr](int a, int b) { return arr[b] < arr[a]; };
    } else {
        cmp = [&arr](int a, int b) { return arr[a] < arr[b]; };
    }

    std::sort(idx.begin(), idx.end(), cmp);
    return idx;
}

std::vector<double> cummin(const std::vector<double>& arr) {
    if (arr.empty()) throw std::runtime_error("cummin requries at least one element");
    std::vector<double> output(arr.size());
    double cumulativeMin = arr[0];
    std::transform(arr.cbegin(), arr.cend(), output.begin(), [&cumulativeMin](double a) {
        if (a < cumulativeMin) cumulativeMin = a;
        return cumulativeMin;
    });
    return output;
}

std::vector<double> cummax(const std::vector<double>& arr) {
    if (arr.empty()) throw std::runtime_error("cummax requries at least one element");
    std::vector<double> output(arr.size());
    double cumulativeMax = arr[0];
    std::transform(arr.cbegin(), arr.cend(), output.begin(), [&cumulativeMax](double a) {
        if (cumulativeMax < a) cumulativeMax = a;
        return cumulativeMax;
    });
    return output;
}

std::vector<double> pminx(const std::vector<double>& arr, double x) {
    if (arr.empty()) throw std::runtime_error("pmin requries at least one element");
    std::vector<double> result(arr.size());
    std::transform(arr.cbegin(), arr.cend(), result.begin(), [&x](double a) {
        if (a < x) return a;
        return x;
    });
    return result;
}

void doubleSay(const std::vector<double>& arr) {
    printf("[ 1] %.10f", arr[0]);
    for (size_t i = 1; i < arr.size(); ++i) {
        printf(" %.10f", arr[i]);
        if ((i + 1) % 5 == 0) printf("\n[%2d]", i + 1);
    }
}

std::vector<double> pAdjust(const std::vector<double>& pvalues, const std::string& str) {
    if (pvalues.empty()) throw std::runtime_error("pAdjust requires at least one element");
    size_t size = pvalues.size();

    int type;
    if ("bh" == str || "fdr" == str) {
        type = 0;
    } else if ("by" == str) {
        type = 1;
    } else if ("bonferroni" == str) {
        type = 2;
    } else if ("hochberg" == str) {
        type = 3;
    } else if ("holm" == str) {
        type = 4;
    } else if ("hommel" == str) {
        type = 5;
    } else {
        throw std::runtime_error(str + " doesn't match any accepted FDR types");
    }

    // Bonferroni method
    if (2 == type) {
        std::vector<double> result(size);
        for (size_t i = 0; i < size; ++i) {
            double b = pvalues[i] * size;
            if (b >= 1) {
                result[i] = 1;
            } else if (0 <= b && b < 1) {
                result[i] = b;
            } else {
                throw std::runtime_error("a value is outside [0, 1)");
            }
        }
        return result;
    }
    // Holm method
    else if (4 == type) {
        auto o = order(pvalues, false);
        std::vector<double> o2Double(o.begin(), o.end());
        std::vector<double> cummaxInput(size);
        for (size_t i = 0; i < size; ++i) {
            cummaxInput[i] = (size - i) * pvalues[o[i]];
        }
        auto ro = order(o2Double, false);
        auto cummaxOutput = cummax(cummaxInput);
        auto pmin = pminx(cummaxOutput, 1.0);
        std::vector<double> result(size);
        std::transform(ro.cbegin(), ro.cend(), result.begin(), [&pmin](int a) { return pmin[a]; });
        return result;
    }
    // Hommel
    else if (5 == type) {
        auto indices = seqLen(size, size);
        auto o = order(pvalues, false);
        std::vector<double> p(size);
        std::transform(o.cbegin(), o.cend(), p.begin(), [&pvalues](int a) { return pvalues[a]; });
        std::vector<double> o2Double(o.begin(), o.end());
        auto ro = order(o2Double, false);
        std::vector<double> q(size);
        std::vector<double> pa(size);
        std::vector<double> npi(size);
        for (size_t i = 0; i < size; ++i) {
            npi[i] = p[i] * size / indices[i];
        }
        double min = *std::min_element(npi.begin(), npi.end());
        std::fill(q.begin(), q.end(), min);
        std::fill(pa.begin(), pa.end(), min);
        for (int j = size; j >= 2; --j) {
            auto ij = seqLen(1, size - j + 1);
            std::transform(ij.cbegin(), ij.cend(), ij.begin(), [](int a) { return a - 1; });
            int i2Length = j - 1;
            std::vector<int> i2(i2Length);
            for (int i = 0; i < i2Length; ++i) {
                i2[i] = size - j + 2 + i - 1;
            }
            double q1 = j * p[i2[0]] / 2.0;
            for (int i = 1; i < i2Length; ++i) {
                double temp_q1 = p[i2[i]] * j / (2.0 + i);
                if (temp_q1 < q1) q1 = temp_q1;
            }
            for (size_t i = 0; i < size - j + 1; ++i) {
                q[ij[i]] = std::min(p[ij[i]] * j, q1);
            }
            for (int i = 0; i < i2Length; ++i) {
                q[i2[i]] = q[size - j];
            }
            for (size_t i = 0; i < size; ++i) {
                if (pa[i] < q[i]) {
                    pa[i] = q[i];
                }
            }
        }
        std::transform(ro.cbegin(), ro.cend(), q.begin(), [&pa](int a) { return pa[a]; });
        return q;
    }

    std::vector<double> ni(size);
    std::vector<int> o = order(pvalues, true);
    std::vector<double> od(o.begin(), o.end());
    for (size_t i = 0; i < size; ++i) {
        if (pvalues[i] < 0 || pvalues[i]>1) {
            throw std::runtime_error("a value is outside [0, 1]");
        }
        ni[i] = (double)size / (size - i);
    }
    auto ro = order(od, false);
    std::vector<double> cumminInput(size);
    if (0 == type) {        // BH method
        for (size_t i = 0; i < size; ++i) {
            cumminInput[i] = ni[i] * pvalues[o[i]];
        }
    } else if (1 == type) { // BY method
        double q = 0;
        for (size_t i = 1; i < size + 1; ++i) {
            q += 1.0 / i;
        }
        for (size_t i = 0; i < size; ++i) {
            cumminInput[i] = q * ni[i] * pvalues[o[i]];
        }
    } else if (3 == type) { // Hochberg method
        for (size_t i = 0; i < size; ++i) {
            cumminInput[i] = (i + 1) * pvalues[o[i]];
        }
    }
    auto cumminArray = cummin(cumminInput);
    auto pmin = pminx(cumminArray, 1.0);
    std::vector<double> result(size);
    for (size_t i = 0; i < size; ++i) {
        result[i] = pmin[ro[i]];
    }
    return result;
}

int main() {
    using namespace std;

    vector<double> pvalues{
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
    };

    vector<vector<double>> correctAnswers{
        // Benjamini-Hochberg
        {
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
        },
        // Benjamini & Yekutieli
        {
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
        },
        // Bonferroni
        {
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
        },
        // Hochberg
        {
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
        },
        // Holm
        {
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
        },
        // Hommel
        {
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
        }
    };

    vector<string> types{ "bh", "by", "bonferroni", "hochberg", "holm", "hommel" };
    for (size_t type = 0; type < types.size(); ++type) {
        auto q = pAdjust(pvalues, types[type]);
        double error = 0.0;
        for (size_t i = 0; i < pvalues.size(); ++i) {
            error += abs(q[i] - correctAnswers[type][i]);
        }
        doubleSay(q);
        printf("\ntype = %d = '%s' has a cumulative error of %g\n\n\n", type, types[type].c_str(), error);
    }

    return 0;
}
