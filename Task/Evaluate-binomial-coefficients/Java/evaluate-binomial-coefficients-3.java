public class Binomial
{
    private static long binom(int n, int k)
    {
        if (k==0)
            return 1;
        else if (k>n-k)
            return binom(n, n-k);
        else
            return binom(n-1, k-1)*n/k;
    }

    public static void main(String[] args)
    {
        System.out.println(binom(5, 3));
    }
}
