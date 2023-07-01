import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

class Program {
    List<Character> sequence;
    Random random;

    SequenceMutation() {
        sequence = new ArrayList<>();
        random = new Random();
    }

    void generate(int amount) {
        for (int count = 0; count < amount; count++)
            sequence.add(randomBase());
    }

    void mutate(int amount) {
        int index;
        for (int count = 0; count < amount; count++) {
            index = random.nextInt(0, sequence.size());
            switch (random.nextInt(0, 3)) {
                case 0 -> sequence.set(index, randomBase());
                case 1 -> sequence.remove(index);
                case 2 -> sequence.add(index, randomBase());
            }
        }
    }

    private char randomBase() {
        return switch (random.nextInt(0, 4)) {
            case 0 -> 'A';
            case 1 -> 'C';
            case 2 -> 'G';
            case 3 -> 'T';
            default -> '?';
        };
    }

    private Base count(String string) {
        int a = 0, c = 0, g = 0, t = 0;
        for (char base : string.toCharArray()) {
            switch (base) {
                case 'A' -> a++;
                case 'C' -> c++;
                case 'G' -> g++;
                case 'T' -> t++;
            }
        }
        return new Base(a, c, g, t);
    }

    /* used exclusively for count totals */
    private record Base(int a, int c, int g, int t) {
        int total() {
            return a + c + g + t;
        }

        @Override
        public String toString() {
            return "[A %2d, C %2d, G %2d, T %2d]".formatted(a, c, g, t);
        }
    }

    @Override
    public String toString() {
        StringBuilder string = new StringBuilder();
        StringBuilder stringB = new StringBuilder();
        String newline = System.lineSeparator();
        for (int index = 0; index < sequence.size(); index++) {
            if (index != 0 && index % 50 == 0)
                string.append(newline);
            string.append(sequence.get(index));
            stringB.append(sequence.get(index));
        }
        try {
            BufferedReader reader = new BufferedReader(new StringReader(string.toString()));
            string = new StringBuilder();
            int count = 0;
            String line;
            while ((line = reader.readLine()) != null) {
                string.append(count++);
                string.append(" %-50s ".formatted(line));
                string.append(count(line));
                string.append(newline);
            }
        } catch (IOException exception) {
            /* ignore */
        }
        string.append(newline);
        Base bases = count(stringB.toString());
        int total = bases.total();
        string.append("Total of %d bases%n".formatted(total));
        string.append("A %3d (%.2f%%)%n".formatted(bases.a, ((double) bases.a / total) * 100));
        string.append("C %3d (%.2f%%)%n".formatted(bases.c, ((double) bases.c / total) * 100));
        string.append("G %3d (%.2f%%)%n".formatted(bases.g, ((double) bases.g / total) * 100));
        string.append("T %3d (%.2f%%)%n".formatted(bases.t, ((double) bases.t / total) * 100));
        return string.toString();
    }
}
