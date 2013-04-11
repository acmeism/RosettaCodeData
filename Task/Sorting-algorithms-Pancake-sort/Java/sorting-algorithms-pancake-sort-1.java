public class PancakeSort
{
   int[] heap;

   public String toString() {
      String info = "";
      for (int x: heap)
         info += x + " ";
      return info;
   }

   public void flip(int n) {
      for (int i = 0; i < (n+1) / 2; ++i) {
         int tmp = heap[i];
         heap[i] = heap[n-i];
         heap[n-i] = tmp;
      }
      System.out.println("flip(0.." + n + "): " + toString());
   }

   public int[] minmax(int n) {
      int xm, xM;
      xm = xM = heap[0];
      int posm = 0, posM = 0;

      for (int i = 1; i < n; ++i) {
         if (heap[i] < xm) {
            xm = heap[i];
            posm = i;
         }
         else if (heap[i] > xM) {
            xM = heap[i];
            posM = i;
         }
      }
      return new int[] {posm, posM};
   }

   public void sort(int n, int dir) {
      if (n == 0) return;

      int[] mM = minmax(n);
      int bestXPos = mM[dir];
      int altXPos = mM[1-dir];
      boolean flipped = false;

      if (bestXPos == n-1) {
         --n;
      }
      else if (bestXPos == 0) {
         flip(n-1);
         --n;
      }
      else if (altXPos == n-1) {
         dir = 1-dir;
         --n;
         flipped = true;
      }
      else {
         flip(bestXPos);
      }
      sort(n, dir);

      if (flipped) {
         flip(n);
      }
   }

   PancakeSort(int[] numbers) {
      heap = numbers;
      sort(numbers.length, 1);
   }

   public static void main(String[] args) {
      int[] numbers = new int[args.length];
      for (int i = 0; i < args.length; ++i)
         numbers[i] = Integer.valueOf(args[i]);

      PancakeSort pancakes = new PancakeSort(numbers);
      System.out.println(pancakes);
   }
}
