internal class Program
{
    private static void Main(string[] args)
    {
        List<int> yellowStoneList = YellowstoneSequence(30);

        Console.WriteLine("Yellowstone 30");

        foreach (int i in yellowStoneList)
        {
            Console.Write(i + " ");
        }
    }

    private static List<int> YellowstoneSequence(int sequenceCount)
    {
        List<int> yellowstoneList = [1, 2, 3];
        int num = 4;
        List<int> notYellowstoneList = new();
        int yellowSize = 3;

        while (yellowSize < sequenceCount)
        {
            int found = -1;

            for (int index = 0; index < notYellowstoneList.Count; index++)
            {
                int test = notYellowstoneList[index];

                if (GCD(yellowstoneList[yellowSize - 2], test) > 1 && GCD(yellowstoneList[yellowSize - 1], test) == 1)
                {
                    found = index;
                    break;
                }
            }

            if (found >= 0)
            {
                yellowstoneList.Add(notYellowstoneList[found]);
                notYellowstoneList.RemoveAt(found);
                yellowSize++;
            }
            else
            {
                while (true)
                {
                    if (GCD(yellowstoneList[yellowSize - 2], num) > 1 && GCD(yellowstoneList[yellowSize - 1], num) == 1)
                    {
                        yellowstoneList.Add(num);
                        yellowSize++;
                        num++;
                        break;
                    }

                    notYellowstoneList.Add(num);
                    num++;
                }
            }
        }

        return yellowstoneList;
    }

    private static int GCD(int a, int b)
    {
        if (b == 0)
        {
            return a;
        }

        return GCD(b, a % b);
    }
}
