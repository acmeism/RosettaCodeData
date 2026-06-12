import java.util.ArrayList;
import java.util.List;



class QuineMcCluskey {

    public static String b2s(int i, int vars) {
        StringBuilder s = new StringBuilder();
        for (int k = 0; k < vars; k++) {
            s.insert(0, ((i & 1) == 1 ? "1" : "0"));
            i >>= 1;
        }
        return s.toString();
    }

    public static int bitCount(String s) {
        int count = 0;
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '1') count++;
        }
        return count;
    }

    public static String merge(String i, String j) {
        int len = Math.min(i.length(), j.length());
        int difCnt = 0;
        StringBuilder s = new StringBuilder();
        for (int k = 0; k < len; k++) {
            char a = i.charAt(k), b = j.charAt(k);
            if (a == 'X' || b == 'X') {
                if (a != b) {
                    return "";
                }
                s.append(a);
            } else if (a != b) {
                difCnt++;
                if (difCnt > 1) {
                    return "";
                }
                s.append('X');
            } else {
                s.append(a);
            }
        }
        return s.toString();
    }

    public static void addToSet(SetType s, String item) {
        for (String str : s.items) {
            if (str.equals(item)) {
                return;
            }
        }
        s.items.add(item);
    }

    public static boolean inSet(SetType s, String item) {
        for (String str : s.items) {
            if (str.equals(item)) {
                return true;
            }
        }
        return false;
    }

    public static void unionSets(SetType dest, SetType src) {
        for (String item : src.items) {
            addToSet(dest, item);
        }
    }

    public static void computePrimes(SetType cubes, int vars, SetType primes) {
        SetType[] sigma = new SetType[vars + 1];
        for (int i = 0; i <= vars; i++) {
            sigma[i] = new SetType();
        }
        int sigmaCount = 0;

        for (int j = 0; j <= vars; j++) {
            for (String cube : cubes.items) {
                if (bitCount(cube) == j) {
                    addToSet(sigma[j], cube);
                }
            }
            if (sigma[j].items.size() > 0) {
                sigmaCount = j + 1;
            }
        }

        primes.items.clear();

        while (sigmaCount > 0) {
            SetType[] nsigma = new SetType[sigmaCount - 1];
            for (int i = 0; i < sigmaCount - 1; i++) {
                nsigma[i] = new SetType();
            }
            SetType redundant = new SetType();

            for (int i = 0; i < sigmaCount - 1; i++) {
                SetType c1 = sigma[i];
                SetType c2 = sigma[i + 1];
                SetType nc = new SetType();

                for (String a : c1.items) {
                    for (String b : c2.items) {
                        String m = merge(a, b);
                        if (!m.equals("")) {
                            addToSet(nc, m);
                            addToSet(redundant, a);
                            addToSet(redundant, b);
                        }
                    }
                }
                nsigma[i] = nc;
            }

            for (int i = 0; i < sigmaCount; i++) {
                for (String cube : sigma[i].items) {
                    if (!inSet(redundant, cube)) {
                        addToSet(primes, cube);
                    }
                }
            }

            sigmaCount = nsigma.length;
            if (sigmaCount > 0) {
                for (int i = 0; i < sigmaCount; i++) {
                    sigma[i] = nsigma[i];
                }
            }
        }
    }

    public static void activePrimes(int cubesel, SetType primes, SetType result) {
        result.items.clear();
        String s = b2s(cubesel, primes.items.size());
        for (int i = 0; i < primes.items.size(); i++) {
            if (s.charAt(i) == '1') {
                addToSet(result, primes.items.get(i));
            }
        }
    }

    public static boolean isCover(String prime, String one) {
        int len = Math.min(prime.length(), one.length());
        for (int i = 0; i < len; i++) {
            char p = prime.charAt(i), o = one.charAt(i);
            if (p != 'X' && p != o) {
                return false;
            }
        }
        return true;
    }

    public static boolean isFullCover(SetType allPrimes, SetType ones) {
        for (String one : ones.items) {
            boolean covered = false;
            for (String prime : allPrimes.items) {
                if (isCover(prime, one)) {
                    covered = true;
                    break;
                }
            }
            if (!covered) {
                return false;
            }
        }
        return true;
    }

    public static void unateCover(SetType primes, SetType ones, SetType result) {
        int minCount = 1000;
        int minSel = -1;
        SetType active = new SetType();

        int total = (1 << primes.items.size());
        for (int cubesel = 0; cubesel < total; cubesel++) {
            activePrimes(cubesel, primes, active);
            if (isFullCover(active, ones)) {
                int cnt = 0;
                String binRep = b2s(cubesel, primes.items.size());
                for (int i = 0; i < binRep.length(); i++) {
                    if (binRep.charAt(i) == '1') cnt++;
                }
                if (cnt < minCount) {
                    minCount = cnt;
                    minSel = cubesel;
                }
            }
        }

        if (minSel != -1) {
            activePrimes(minSel, primes, result);
        } else {
            result.items.clear();
        }
    }

    public static SetType qm(int[] ones, int[] zeros, int[] dc) {
        SetType result = new SetType();

        if (ones.length == 0 && zeros.length == 0 && dc.length == 0) {
            return result;
        }

        int maxVal = 0;
        for (int val : ones) if (val > maxVal) maxVal = val;
        for (int val : zeros) if (val > maxVal) maxVal = val;
        for (int val : dc) if (val > maxVal) maxVal = val;

        int numvars = 0;
        if (maxVal == 0) {
            numvars = 1;
        } else {
            int tmp = maxVal;
            while (tmp > 0) {
                numvars++;
                tmp >>= 1;
            }
        }

        SetType onesSet = new SetType();
        SetType zerosSet = new SetType();
        SetType dcSet = new SetType();

        for (int val : ones) {
            addToSet(onesSet, b2s(val, numvars));
        }
        for (int val : zeros) {
            addToSet(zerosSet, b2s(val, numvars));
        }
        for (int val : dc) {
            addToSet(dcSet, b2s(val, numvars));
        }

        SetType cubes = new SetType();
        unionSets(cubes, onesSet);
        unionSets(cubes, dcSet);

        SetType primes = new SetType();
        computePrimes(cubes, numvars, primes);

        unateCover(primes, onesSet, result);
        return result;
    }

    public static void main(String[] args) {
        int[] ones = {1, 2, 5};
        int[] zeros = {};
        int[] dc = {0, 7};

        SetType result = qm(ones, zeros, dc);

        StringBuilder output = new StringBuilder();
        for (String item : result.items) {
            if (output.length() > 0) {
                output.append(" ");
            }
            output.append(item);
        }
        System.out.println(output.toString());
    }
}


class SetType {
    List<String> items;

    public SetType() {
        this.items = new ArrayList<>();
    }
}
