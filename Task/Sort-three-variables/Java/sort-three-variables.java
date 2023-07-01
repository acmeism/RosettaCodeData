import java.util.Comparator;
import java.util.stream.Stream;

class Box {
    public int weightKg;

    Box(final int weightKg) {
        this.weightKg = weightKg;
    }
}

public class Sort3Vars {
    public static void main(String... args) {
        int iA = 21;
        int iB = 11;
        int iC = 82;
        int[] sortedInt = Stream.of(iA, iB, iC).sorted().mapToInt(Integer::intValue).toArray();
        iA = sortedInt[0];
        iB = sortedInt[1];
        iC = sortedInt[2];
        System.out.printf("Sorted values: %d %d %d%n", iA, iB, iC);

        String sA = "s21";
        String sB = "s11";
        String sC = "s82";
        Object[] sortedStr = Stream.of(sA, sB, sC).sorted().toArray();
        sA = (String) sortedStr[0];
        sB = (String) sortedStr[1];
        sC = (String) sortedStr[2];
        System.out.printf("Sorted values: %s %s %s%n", sA, sB, sC);

        Box bA = new Box(200);
        Box bB = new Box(12);
        Box bC = new Box(143);
        // Provides a comparator for Box instances
        Object[] sortedBox = Stream.of(bA, bB, bC).sorted(Comparator.comparingInt(a -> a.weightKg)).toArray();
        bA = (Box) sortedBox[0];
        bB = (Box) sortedBox[1];
        bC = (Box) sortedBox[2];
        System.out.printf("Sorted Boxes: %dKg %dKg %dKg%n", bA.weightKg, bB.weightKg, bC.weightKg);
    }
}
