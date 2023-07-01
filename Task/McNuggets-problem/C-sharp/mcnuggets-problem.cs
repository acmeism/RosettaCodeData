using System;

public class McNuggets
{
   public static void Main()
   {
      bool[] isMcNuggetNumber = new bool[101];

      for (int x = 0; x <= 100/6; x++)
      {
         for (int y = 0; y <= 100/9; y++)
         {
            for (int z = 0; z <= 100/20; z++)
            {
               int mcNuggetNumber = x*6 + y*9 + z*20;
               if (mcNuggetNumber <= 100)
               {
                  isMcNuggetNumber[mcNuggetNumber] = true;
               }
            }
         }
      }

      for (int mnnCheck = isMcNuggetNumber.Length-1; mnnCheck >= 0; mnnCheck--)
      {
         if (!isMcNuggetNumber[mnnCheck])
         {
            Console.WriteLine("Largest non-McNuggett Number less than 100: " + mnnCheck.ToString());
            break;
         }
      }
   }
}
