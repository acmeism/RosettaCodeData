using System;

namespace rref
{
    class Program
    {
        static void Main(string[] args)
        {
            int[,] matrix = new int[3, 4]{
                {  1, 2, -1,  -4 },
                {  2, 3, -1, -11 },
                { -2, 0, -3,  22 }
            };
            matrix = rref(matrix);
        }

        private static int[,] rref(int[,] matrix)
        {
            int lead = 0, rowCount = matrix.GetLength(0), columnCount = matrix.GetLength(1);
            for (int r = 0; r < rowCount; r++)
            {
                if (columnCount <= lead) break;
                int i = r;
                while (matrix[i, lead] == 0)
                {
                    i++;
                    if (i == rowCount)
                    {
                        i = r;
                        lead++;
                        if (columnCount == lead)
                        {
                        lead--;
                        break;
                        }
                    }
                }
                for (int j = 0; j < columnCount; j++)
                {
                    int temp = matrix[r, j];
                    matrix[r, j] = matrix[i, j];
                    matrix[i, j] = temp;
                }
                int div = matrix[r, lead];
                if(div != 0)
                    for (int j = 0; j < columnCount; j++) matrix[r, j] /= div;
                for (int j = 0; j < rowCount; j++)
                {
                    if (j != r)
                    {
                        int sub = matrix[j, lead];
                        for (int k = 0; k < columnCount; k++) matrix[j, k] -= (sub * matrix[r, k]);
                    }
                }
                lead++;
            }
            return matrix;
        }
    }
}
