public class Binomial
{
    private static long binomial(int n, int k)
    {
        if (k>n-k)
            k=n-k;

        long b=1;
        for (int i=1, m=n; i<=k; i++, m--)
            b=b*m/i;
        return b;
    }

    public static void main(String[] args)
    {
        System.out.println(binomial(5, 3));
    }
}
