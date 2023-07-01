        public static void Multiloop(char[] A, char[] B, int[] C)
        {
            var max = Math.Max(Math.Max(A.Length, B.Length), C.Length);
            for (int i = 0; i < max; i++)
               Console.WriteLine($"{(i < A.Length ? A[i] : ' ')}, {(i < B.Length ? B[i] : ' ')}, {(i < C.Length ? C[i] : ' ')}");
        }
