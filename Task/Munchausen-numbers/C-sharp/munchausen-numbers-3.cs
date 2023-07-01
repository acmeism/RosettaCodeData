using System;

static class Program
{
    public static void Main()
    {
        long sum, ten1 = 0, ten2 = 10; byte [] num; int [] pow = new int[10];
        int i, j, n, n1, n2, n3, n4, n5, n6, n7, n8, n9, s2, s3, s4, s5, s6, s7, s8;
        for (i = 1; i <= 9; i++) { pow[i] = i; for (j = 2; j <= i; j++) pow[i] *= i; }
        for (n = 1; n <= 11; n++) { for (n9 = 0; n9 <= n; n9++) { for (n8 = 0; n8 <= n - n9; n8++) {
              for (n7 = 0; n7 <= n - (s8 = n9 + n8); n7++) { for (n6 = 0; n6 <= n - (s7 = s8 + n7); n6++) {
                  for (n5 = 0; n5 <= n - (s6 = s7 + n6); n5++) { for (n4 = 0; n4 <= n - (s5 = s6 + n5); n4++) {
                      for (n3 = 0; n3 <= n - (s4 = s5 + n4); n3++) { for (n2 = 0; n2 <= n - (s3 = s4 + n3); n2++) {
                          for (n1 = 0; n1 <= n - (s2 = s3 + n2); n1++) {
                            sum = n1 * pow[1] + n2 * pow[2] + n3 * pow[3] + n4 * pow[4] +
                                  n5 * pow[5] + n6 * pow[6] + n7 * pow[7] + n8 * pow[8] + n9 * pow[9];
                            if (sum < ten1 || sum >= ten2) continue;
                            num = new byte[10]; foreach (char ch in sum.ToString()) num[Convert.ToByte(ch) - 48] += 1;
                            if (n - (s2 + n1) == num[0] && n1 == num[1] && n2 == num[2]
                              && n3 == num[3] && n4 == num[4] && n5 == num[5] && n6 == num[6]
                              && n7 == num[7] && n8 == num[8] && n9 == num[9]) Console.WriteLine(sum);
                          } } } } } } } } }
          ten1 = ten2; ten2 *= 10;
        }
    }
}
