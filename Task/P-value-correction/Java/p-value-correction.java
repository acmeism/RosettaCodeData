import java.util.Arrays;
import java.util.Comparator;

public class PValueCorrection {
    private static int[] seqLen(int start, int end) {
        int[] result;
        if (start == end) {
            result = new int[end + 1];
            for (int i = 0; i < result.length; ++i) {
                result[i] = i + 1;
            }
        } else if (start < end) {
            result = new int[end - start + 1];
            for (int i = 0; i < result.length; ++i) {
                result[i] = start + i;
            }
        } else {
            result = new int[start - end + 1];
            for (int i = 0; i < result.length; ++i) {
                result[i] = start - i;
            }
        }
        return result;
    }

    private static int[] order(double[] array, boolean decreasing) {
        int size = array.length;
        int[] idx = new int[size];
        double[] baseArr = new double[size];
        for (int i = 0; i < size; ++i) {
            baseArr[i] = array[i];
            idx[i] = i;
        }

        Comparator<Integer> cmp;
        if (!decreasing) {
            cmp = Comparator.comparingDouble(a -> baseArr[a]);
        } else {
            cmp = (a, b) -> Double.compare(baseArr[b], baseArr[a]);
        }

        return Arrays.stream(idx)
            .boxed()
            .sorted(cmp)
            .mapToInt(a -> a)
            .toArray();
    }

    private static double[] cummin(double[] array) {
        if (array.length < 1) throw new IllegalArgumentException("cummin requires at least one element");
        double[] output = new double[array.length];
        double cumulativeMin = array[0];
        for (int i = 0; i < array.length; ++i) {
            if (array[i] < cumulativeMin) cumulativeMin = array[i];
            output[i] = cumulativeMin;
        }
        return output;
    }

    private static double[] cummax(double[] array) {
        if (array.length < 1) throw new IllegalArgumentException("cummax requires at least one element");
        double[] output = new double[array.length];
        double cumulativeMax = array[0];
        for (int i = 0; i < array.length; ++i) {
            if (array[i] > cumulativeMax) cumulativeMax = array[i];
            output[i] = cumulativeMax;
        }
        return output;
    }

    private static double[] pminx(double[] array, double x) {
        if (array.length < 1) throw new IllegalArgumentException("pmin requires at least one element");
        double[] result = new double[array.length];
        for (int i = 0; i < array.length; ++i) {
            if (array[i] < x) {
                result[i] = array[i];
            } else {
                result[i] = x;
            }
        }
        return result;
    }

    private static void doubleSay(double[] array) {
        System.out.printf("[ 1] %e", array[0]);
        for (int i = 1; i < array.length; ++i) {
            System.out.printf(" %.10f", array[i]);
            if ((i + 1) % 5 == 0) System.out.printf("\n[%2d]", i + 1);
        }
        System.out.println();
    }

    private static double[] intToDouble(int[] array) {
        double[] result = new double[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    private static double doubleArrayMin(double[] array) {
        if (array.length < 1) throw new IllegalArgumentException("pAdjust requires at least one element");
        return Arrays.stream(array).min().orElse(Double.NaN);
    }

    private static double[] pAdjust(double[] pvalues, String str) {
        int size = pvalues.length;
        if (size < 1) throw new IllegalArgumentException("pAdjust requires at least one element");
        int type;
        switch (str.toLowerCase()) {
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
                throw new IllegalArgumentException(str + " doesn't match any accepted FDR types");
        }

        if (type == 2) {  // Bonferroni method
            double[] result = new double[size];
            for (int i = 0; i < size; ++i) {
                double b = pvalues[i] * size;
                if (b >= 1) {
                    result[i] = 1;
                } else if (0 <= b && b < 1) {
                    result[i] = b;
                } else {
                    throw new RuntimeException("" + b + " is outside [0, 1)");
                }
            }
            return result;
        } else if (type == 4) {  // Holm method
            int[] o = order(pvalues, false);
            double[] o2Double = intToDouble(o);
            double[] cummaxInput = new double[size];
            for (int i = 0; i < size; ++i) {
                cummaxInput[i] = (size - i) * pvalues[o[i]];
            }
            int[] ro = order(o2Double, false);
            double[] cummaxOutput = cummax(cummaxInput);
            double[] pmin = pminx(cummaxOutput, 1.0);
            double[] result = new double[size];
            for (int i = 0; i < size; ++i) {
                result[i] = pmin[ro[i]];
            }
            return result;
        } else if (type == 5) {
            int[] indices = seqLen(size, size);
            int[] o = order(pvalues, false);
            double[] p = new double[size];
            for (int i = 0; i < size; ++i) {
                p[i] = pvalues[o[i]];
            }
            double[] o2Double = intToDouble(o);
            int[] ro = order(o2Double, false);
            double[] q = new double[size];
            double[] pa = new double[size];
            double[] npi = new double[size];
            for (int i = 0; i < size; ++i) {
                npi[i] = p[i] * size / indices[i];
            }
            double min = doubleArrayMin(npi);
            Arrays.fill(q, min);
            Arrays.fill(pa, min);
            for (int j = size; j >= 2; --j) {
                int[] ij = seqLen(1, size - j + 1);
                for (int i = 0; i < size - j + 1; ++i) {
                    ij[i]--;
                }
                int i2Length = j - 1;
                int[] i2 = new int[i2Length];
                for (int i = 0; i < i2Length; ++i) {
                    i2[i] = size - j + 2 + i - 1;
                }
                double q1 = j * p[i2[0]] / 2.0;
                for (int i = 1; i < i2Length; ++i) {
                    double temp_q1 = p[i2[i]] * j / (2.0 + i);
                    if (temp_q1 < q1) q1 = temp_q1;
                }
                for (int i = 0; i < size - j + 1; ++i) {
                    q[ij[i]] = Math.min(p[ij[i]] * j, q1);
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
                q[i] = pa[ro[i]];
            }
            return q;
        }

        double[] ni = new double[size];
        int[] o = order(pvalues, true);
        double[] oDouble = intToDouble(o);
        for (int i = 0; i < size; ++i) {
            if (pvalues[i] < 0 || pvalues[i] > 1) {
                throw new RuntimeException("array[" + i + "] = " + pvalues[i] + " is outside [0, 1]");
            }
            ni[i] = (double) size / (size - i);
        }
        int[] ro = order(oDouble, false);
        double[] cumminInput = new double[size];
        if (type == 0) {  // BH method
            for (int i = 0; i < size; ++i) {
                cumminInput[i] = ni[i] * pvalues[o[i]];
            }
        } else if (type == 1) {  // BY method
            double q = 0;
            for (int i = 1; i < size + 1; ++i) {
                q += 1.0 / i;
            }
            for (int i = 0; i < size; ++i) {
                cumminInput[i] = q * ni[i] * pvalues[o[i]];
            }
        } else if (type == 3) {  // Hochberg method
            for (int i = 0; i < size; ++i) {
                cumminInput[i] = (i + 1) * pvalues[o[i]];
            }
        }
        double[] cumminArray = cummin(cumminInput);
        double[] pmin = pminx(cumminArray, 1.0);
        double[] result = new double[size];
        for (int i = 0; i < size; ++i) {
            result[i] = pmin[ro[i]];
        }
        return result;
    }

    public static void main(String[] args) {
        double[] pvalues = new double[]{
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

        double[][] correctAnswers = new double[][]{
            new double[]{  // Benjamini-Hochberg
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
            new double[]{  // Benjamini & Yekutieli
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
            new double[]{  // Bonferroni
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
            new double[]{  // Hochberg
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
            new double[]{  // Holm
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
            new double[]{  // Hommel
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

        String[] types = new String[]{"bh", "by", "bonferroni", "hochberg", "holm", "hommel"};
        for (int type = 0; type < types.length; ++type) {
            double[] q = pAdjust(pvalues, types[type]);
            double error = 0.0;
            for (int i = 0; i < pvalues.length; ++i) {
                error += Math.abs(q[i] - correctAnswers[type][i]);
            }
            doubleSay(q);
            System.out.printf("\ntype %d = '%s' has a cumulative error of %g\n", type, types[type], error);
        }
    }
}
