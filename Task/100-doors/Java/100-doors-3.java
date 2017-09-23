import java.util.stream.Collectors;
import java.util.stream.IntStream;

class HundredDoors {
    public static void main(String args[]) {
        String openDoors = IntStream.rangeClosed(1, 100)
                .filter(i -> Math.pow((int) Math.sqrt(i), 2) == i)
                .mapToObj(Integer::toString)
                .collect(Collectors.joining(", "));
        System.out.printf("Open doors: %s%n", openDoors);
    }
}
