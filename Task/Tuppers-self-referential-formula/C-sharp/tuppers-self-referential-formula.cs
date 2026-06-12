using System;
using System.Numerics;

class TuppersSelfReferentialFormula
{
    private static readonly BigInteger k = BigInteger.Parse("960939379918958884971672962127852754715" +
        "004339660129306651505519271702802395266424689642842174350718121267153782" +
        "770623355993237280874144307891325963941337723487857735749823926629715517" +
        "173716995165232890538221612403238855866184013235585136048828693337902491" +
        "454229288667081096184496091705183454067827731551705405381627380967602565" +
        "625016981482083418783163849115590225610003652351370343874461848378737238" +
        "198224849863465033159410054974700593138339226497249461751545728366702369" +
        "745461014655997933798537483143786841806593422227898388722980000748404719");

    static void Main(string[] args)
    {
        bool[,] matrix = TuppersMatrix();

        Console.BackgroundColor = ConsoleColor.Magenta;
        for (int row = 0; row < 17; row++)
        {
            for (int column = 0; column < 106; column++)
            {
                Console.Write(matrix[row, column] ? "█" : " ");
            }
            Console.WriteLine();
        }
        Console.ResetColor(); // Resets to the default console background and foreground colors
    }

    private static bool[,] TuppersMatrix()
    {
        bool[,] matrix = new bool[17, 106];
        BigInteger seventeen = new BigInteger(17);

        for (int column = 0; column < 106; column++)
        {
            for (int row = 0; row < 17; row++)
            {
                BigInteger y = k + row;
                BigInteger a = y / seventeen;
                int bb = (int)(y % seventeen) + column * 17;
                BigInteger b = BigInteger.Pow(2, bb);
                a /= b;
                int aa = (int)(a % 2);
                matrix[row, 105 - column] = (aa == 1);
            }
        }
        return matrix;
    }
}
