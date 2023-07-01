import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class RSortingRadixsort00 {

  public RSortingRadixsort00() {

    return;
  }

  public static int[] lsdRadixSort(int[] tlist) {

    List<Integer> intermediates;
    int[] limits = getLimits(tlist);
    tlist = rescale(tlist, limits[1]);

    for (int px = 1; px <= limits[2]; ++px) {
      @SuppressWarnings("unchecked")
      Queue<Integer> bukits[] = new Queue[10];
      for (int ix = 0; ix < tlist.length; ++ix) {
        int cval = tlist[ix];
        int digit = (int) (cval / Math.pow(10, px - 1) % 10);
        if (bukits[digit] == null) {
          bukits[digit] = new LinkedList<>();
        }
        bukits[digit].add(cval);
      }

      intermediates = new ArrayList<>();
      for (int bi = 0; bi < 10; ++bi) {
        if (bukits[bi] != null) {
          while (bukits[bi].size() > 0) {
            int nextd;
            nextd = bukits[bi].poll();
            intermediates.add(nextd);
          }
        }
      }

      for (int iw = 0; iw < intermediates.size(); ++iw) {
        tlist[iw] = intermediates.get(iw);
      }
    }

    tlist = rescale(tlist, -limits[1]);

    return tlist;
  }

  private static int[] rescale(int[] arry, int delta) {

    for (int ix = 0; ix < arry.length; ++ix) {
      arry[ix] -= delta;
    }

    return arry;
  }

  private static int[] getLimits(int[] tlist) {

    int[] lims = new int[3];

    for (int i_ = 0; i_ < tlist.length; ++i_) {
      lims[0] = Math.max(lims[0], tlist[i_]);
      lims[1] = Math.min(lims[1], tlist[i_]);
    }
    lims[2] = (int) Math.ceil(Math.log10(lims[0] - lims[1]));

    return lims;
  }

  private static void runSample(String[] args) {

    int[][] lists = {
      new int[] { 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, },
      new int[] { -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, -0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, },
      new int[] { 2, 24, 45, 0, 66, 75, 170, -802, -90, 1066, 666, },
      new int[] { 170, 45, 75, 90, 2, 24, 802, 66, },
      new int[] { -170, -45, -75, -90, -2, -24, -802, -66, },
    };

    long etime;
    lsdRadixSort(Arrays.copyOf(lists[0], lists[0].length)); // do one pass to set up environment to remove it from timings

    for (int[] tlist : lists) {
      System.out.println(array2list(tlist));
      etime = System.nanoTime();
      tlist = lsdRadixSort(tlist);
      etime = System.nanoTime() - etime;
      System.out.println(array2list(tlist));
      System.out.printf("Elapsed time: %fs%n", ((double) etime / 1_000_000_000.0));
      System.out.println();
    }

    return;
  }

  private static List<Integer> array2list(int[] arry) {

    List<Integer> target = new ArrayList<>(arry.length);

    for (Integer iv : arry) {
      target.add(iv);
    }

    return target;
  }

  public static void main(String[] args) {

    runSample(args);

    return;
  }
}
