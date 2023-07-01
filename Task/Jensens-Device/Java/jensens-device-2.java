public class Jensen2 {

    interface IntToDoubleFunction {
        double apply(int n);
    }

    static double sum(int lo, int hi, IntToDoubleFunction f) {
        double res = 0;
        for (int i = lo; i <= hi; i++)
            res += f.apply(i);
        return res;

    }
    public static void main(String args[]) {
        System.out.println(
            sum(1, 100,
                new IntToDoubleFunction() {
                    public double apply(int i) { return 1.0/i;}
                }));
    }
}
