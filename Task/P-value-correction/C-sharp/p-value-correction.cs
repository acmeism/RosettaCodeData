using System;
using System.Collections.Generic;
using System.Linq;

namespace PValueCorrection {
    class Program {
        static List<int> SeqLen(int start, int end) {
            var result = new List<int>();
            if (start == end) {
                for (int i = 0; i < end + 1; ++i) {
                    result.Add(i + 1);
                }
            } else if (start < end) {
                for (int i = 0; i < end - start + 1; ++i) {
                    result.Add(start + i);
                }
            } else {
                for (int i = 0; i < start - end + 1; ++i) {
                    result.Add(start - i);
                }
            }
            return result;
        }

        static List<int> Order(List<double> array, bool decreasing) {
            List<int> idx = new List<int>();
            for (int i = 0; i < array.Count; ++i) {
                idx.Add(i);
            }

            IComparer<int> cmp;
            if (decreasing) {
                cmp = Comparer<int>.Create((a, b) => array[a] < array[b] ? 1 : array[b] < array[a] ? -1 : 0);
            } else {
                cmp = Comparer<int>.Create((a, b) => array[b] < array[a] ? 1 : array[a] < array[b] ? -1 : 0);
            }

            idx.Sort(cmp);
            return idx;
        }

        static List<double> Cummin(List<double> array) {
            if (array.Count < 1) throw new ArgumentOutOfRangeException("cummin requires at least one element");
            var output = new List<double>();
            double cumulativeMin = array[0];
            for (int i = 0; i < array.Count; ++i) {
                if (array[i] < cumulativeMin) cumulativeMin = array[i];
                output.Add(cumulativeMin);
            }
            return output;
        }

        static List<double> Cummax(List<double> array) {
            if (array.Count < 1) throw new ArgumentOutOfRangeException("cummax requires at least one element");
            var output = new List<double>();
            double cumulativeMax = array[0];
            for (int i = 0; i < array.Count; ++i) {
                if (array[i] > cumulativeMax) cumulativeMax = array[i];
                output.Add(cumulativeMax);
            }
            return output;
        }

        static List<double> Pminx(List<double> array, double x) {
            if (array.Count < 1) throw new ArgumentOutOfRangeException("pmin requires at least one element");
            var result = new List<double>();
            for (int i = 0; i < array.Count; ++i) {
                if (array[i] < x) {
                    result.Add(array[i]);
                } else {
                    result.Add(x);
                }
            }
            return result;
        }

        static void Say(List<double> array) {
            Console.Write("[ 1] {0:E}", array[0]);
            for (int i = 1; i < array.Count; ++i) {
                Console.Write(" {0:E}", array[i]);
                if ((i + 1) % 5 == 0) Console.Write("\n[{0,2}]", i + 1);
            }
            Console.WriteLine();
        }

        static List<double> PAdjust(List<double> pvalues, string str) {
            var size = pvalues.Count;
            if (size < 1) throw new ArgumentOutOfRangeException("pAdjust requires at least one element");

            int type;
            switch (str.ToLower()) {
                case "bh":
                case "fdr":
                    type = 0;
                    break;
                case "by":
                    type = 1;
                    break;
                case "bonferroni":
                    type = 2;
                    break;
                case "hochberg":
                    type = 3;
                    break;
                case "holm":
                    type = 4;
                    break;
                case "hommel":
                    type = 5;
                    break;
                default:
                    throw new ArgumentException(str + " doesn't match any accepted FDR types");
            }

            if (2 == type) { // Bonferroni method
                var result2 = new List<double>();
                for (int i = 0; i < size; ++i) {
                    double b = pvalues[i] * size;
                    if (b >= 1) {
                        result2.Add(1);
                    } else if (0 <= b && b < 1) {
                        result2.Add(b);
                    } else {
                        throw new Exception(b + " is outside [0, 1)");
                    }
                }
                return result2;
            } else if (4 == type) { // Holm method
                var o4 = Order(pvalues, false);
                var o4d = o4.ConvertAll(x => (double)x);
                var cummaxInput = new List<double>();
                for (int i = 0; i < size; ++i) {
                    cummaxInput.Add((size - i) * pvalues[o4[i]]);
                }
                var ro4 = Order(o4d, false);
                var cummaxOutput = Cummax(cummaxInput);
                var pmin4 = Pminx(cummaxOutput, 1.0);
                var hr = new List<double>();
                for (int i = 0; i < size; ++i) {
                    hr.Add(pmin4[ro4[i]]);
                }
                return hr;
            } else if (5 == type) { // Hommel method
                var indices = SeqLen(size, size);
                var o5 = Order(pvalues, false);
                var p = new List<double>();
                for (int i = 0; i < size; ++i) {
                    p.Add(pvalues[o5[i]]);
                }
                var o5d = o5.ConvertAll(x => (double)x);
                var ro5 = Order(o5d, false);
                var q = new List<double>();
                var pa = new List<double>();
                var npi = new List<double>();
                for (int i = 0; i < size; ++i) {
                    npi.Add(p[i] * size / indices[i]);
                }
                double min = npi.Min();
                q.AddRange(Enumerable.Repeat(min, size));
                pa.AddRange(Enumerable.Repeat(min, size));
                for (int j = size; j >= 2; --j) {
                    var ij = SeqLen(1, size - j + 1);
                    for (int i = 0; i < size - j + 1; ++i) {
                        ij[i]--;
                    }
                    int i2Length = j - 1;
                    var i2 = new List<int>();
                    for (int i = 0; i < i2Length; ++i) {
                        i2.Add(size - j + 2 + i - 1);
                    }
                    double q1 = j * p[i2[0]] / 2.0;
                    for (int i = 1; i < i2Length; ++i) {
                        double temp_q1 = p[i2[i]] * j / (2.0 + i);
                        if (temp_q1 < q1) q1 = temp_q1;
                    }
                    for (int i = 0; i < size - j + 1; ++i) {
                        q[ij[i]] = Math.Min(p[ij[i]] * j, q1);
                    }
                    for (int i = 0; i < i2Length; ++i) {
                        q[i2[i]] = q[size - j];
                    }
                    for (int i = 0; i < size; ++i) {
                        if (pa[i] < q[i]) {
                            pa[i] = q[i];
                        }
                    }
                }
                for (int i = 0; i < size; ++i) {
                    q[i] = pa[ro5[i]];
                }
                return q;
            }

            var ni = new List<double>();
            var o = Order(pvalues, true);
            var od = o.ConvertAll(x => (double)x);
            for (int i = 0; i < size; ++i) {
                if (pvalues[i] < 0 || pvalues[i] > 1) {
                    throw new Exception("array[" + i + "] = " + pvalues[i] + " is outside [0, 1]");
                }
                ni.Add((double)size / (size - i));
            }
            var ro = Order(od, false);
            var cumminInput = new List<double>();
            if (0 == type) {       // BH method
                for (int i = 0; i < size; ++i) {
                    cumminInput.Add(ni[i] * pvalues[o[i]]);
                }
            } else if (1 == type) { // BY method
                double q = 0;
                for (int i = 1; i < size + 1; ++i) {
                    q += 1.0 / i;
                }
                for (int i = 0; i < size; ++i) {
                    cumminInput.Add(q * ni[i] * pvalues[o[i]]);
                }
            } else if (3 == type) { // Hochberg method
                for (int i = 0; i < size; ++i) {
                    cumminInput.Add((i + 1) * pvalues[o[i]]);
                }
            }
            var cumminArray = Cummin(cumminInput);
            var pmin = Pminx(cumminArray, 1.0);
            var result = new List<double>();
            for (int i = 0; i < size; ++i) {
                result.Add(pmin[ro[i]]);
            }
            return result;
        }

        static void Main(string[] args) {
            var pvalues = new List<double> {
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
            var correctAnswers = new List<List<double>> {
                new List<double> { // Benjamini-Hochberg
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
                new List<double> { // Benjamini & Yekutieli
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
                new List<double> { // Bonferroni
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
                new List<double> { // Hochberg
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
                new List<double> { // Holm
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
                new List<double> { // Hommel
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

            string[] types = { "bh", "by", "bonferroni", "hochberg", "holm", "hommel" };
            for (int type = 0; type < types.Length; ++type) {
                var q = PAdjust(pvalues, types[type]);
                double error = 0.0;
                for (int i = 0; i < pvalues.Count; ++i) {
                    error += Math.Abs(q[i] - correctAnswers[type][i]);
                }
                Say(q);
                Console.WriteLine("type {0} = '{1}' has a cumulative error of {2:E}", type, types[type], error);
                Console.WriteLine();
            }
        }
    }
}
