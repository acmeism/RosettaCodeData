import java.math.BigInteger;

public class PopCount {
    public static void main(String[] args) {
	{ // with int
	    System.out.print("32-bit integer: ");
	    int n = 1;
	    for (int i = 0; i < 20; i++) {
		System.out.printf("%d ", Integer.bitCount(n));
		n *= 3;
	    }
	    System.out.println();
	}
	{ // with long
	    System.out.print("64-bit integer: ");
	    long n = 1;
	    for (int i = 0; i < 30; i++) {
		System.out.printf("%d ", Long.bitCount(n));
		n *= 3;
	    }
	    System.out.println();
	}
	{ // with BigInteger
	    System.out.print("big integer   : ");
	    BigInteger n = BigInteger.ONE;
	    BigInteger three = BigInteger.valueOf(3);
	    for (int i = 0; i < 30; i++) {
		System.out.printf("%d ", n.bitCount());
		n = n.multiply(three);
	    }
	    System.out.println();
	}

	int[] od = new int[30];
	int ne = 0, no = 0;
	System.out.print("evil   : ");
	for (int n = 0; ne+no < 60; n++) {
	    if ((Integer.bitCount(n) & 1) == 0) {
		if (ne < 30) {
		    System.out.printf("%d ", n);
		    ne++;
		}
	    } else {
		if (no < 30) {
		    od[no++] = n;
		}
	    }
	}
	System.out.println();
	System.out.print("odious : ");
	for (int n : od) {
	    System.out.printf("%d ", n);
	}
	System.out.println();
    }
}
