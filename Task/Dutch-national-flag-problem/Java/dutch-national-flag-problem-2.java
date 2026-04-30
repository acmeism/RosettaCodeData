// Dutch national flag problem

public class Main {

  enum Color {BLUE, WHITE, RED};

  static final int N = 20;

  static void printColorSeq(Color[] t) {
    int n = t.length;
    for (int i = 0; i < n; i++) {
      switch (t[i]) {
      case BLUE:
        System.out.print("B");
        break;
      case WHITE:
        System.out.print("W");
        break;
      case RED:
        System.out.print("R");
        break;
      }
    }
    System.out.println();
  }

  static void swapElems(Color[] arr, int i, int j) {
    Color temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  static void sortByColor(Color[] t) {
    int b = 0, w = 0, r = t.length - 1;
    while (w <= r) {
      switch (t[w]) {
      case WHITE:
        w++;
        break;
      case BLUE:
        swapElems(t, b, w);
        b++;
        w++;
        break;
      case RED:
        swapElems(t, w, r);
        r--;
        break;
      }
    }
  }

  public static void main(String[] args) {
    Color[] t = new Color[N];

    // Set colors
    for (int i = 0; i < N; i++) {
      int ci = (int)(Math.random() * 3);
      switch (ci) {
      case 0:
        t[i] = Color.BLUE;
        break;
      case 1:
        t[i] = Color.WHITE;
        break;
      case 2:
        t[i] = Color.RED;
        break;
      }
    }

    System.out.println("Unsorted:");
    printColorSeq(t);
    sortByColor(t);
    System.out.println();
    System.out.println("Sorted:");
    printColorSeq(t);
  }
}
