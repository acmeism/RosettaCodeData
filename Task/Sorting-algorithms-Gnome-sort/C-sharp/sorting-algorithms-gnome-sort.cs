        public static void gnomeSort(int[] anArray)
        {
            int first = 1;
            int second = 2;

            while (first < anArray.Length)
            {
                if (anArray[first - 1] <= anArray[first])
                {
                    first = second;
                    second++;
                }
                else
                {
                    int tmp = anArray[first - 1];
                    anArray[first - 1] = anArray[first];
                    anArray[first] = tmp;
                    first -= 1;
                    if (first == 0)
                    {
                        first = 1;
                        second = 2;
                    }
                }

            }
        }
