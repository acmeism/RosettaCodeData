public class FindPrime
{
   Array<int> primeList { [ 2 ], minAllocSize = 64 };
   int index;

   index = 3;

   bool HasPrimeFactor(int x)
   {
      int max = (int)floor(sqrt((double)x));

      for(i : primeList)
      {
         if(i > max) break;
         if(x % i == 0) return true;
      }
      return false;
   }

   public int GetPrime(int x)
   {
      if(x > primeList.count - 1)
      {
         for (; primeList.count != x; index += 2)
            if(!HasPrimeFactor(index))
            {
               if(primeList.count >= primeList.minAllocSize) primeList.minAllocSize *= 2;
               primeList.Add(index);
            }
      }
      return primeList[x-1];
   }
}

class PrimeApp : Application
{
   FindPrime fp { };
   void Main()
   {
      int num = argc > 1 ? atoi(argv[1]) : 1;
      PrintLn(fp.GetPrime(num));
   }
}
