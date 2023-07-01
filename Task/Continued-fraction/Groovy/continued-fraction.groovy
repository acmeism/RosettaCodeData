import java.util.function.Function

import static java.lang.Math.pow

class Test {
    static double calc(Function<Integer, Integer[]> f, int n) {
        double temp = 0

        for (int ni = n; ni >= 1; ni--) {
            Integer[] p = f.apply(ni)
            temp = p[1] / (double) (p[0] + temp)
        }
        return f.apply(0)[0] + temp
    }

    static void main(String[] args) {
        List<Function<Integer, Integer[]>> fList = new ArrayList<>()
        fList.add({ n -> [n > 0 ? 2 : 1, 1] })
        fList.add({ n -> [n > 0 ? n : 2, n > 1 ? (n - 1) : 1] })
        fList.add({ n -> [n > 0 ? 6 : 3, (int) pow(2 * n - 1, 2)] })

        for (Function<Integer, Integer[]> f : fList)
            System.out.println(calc(f, 200))
    }
}
