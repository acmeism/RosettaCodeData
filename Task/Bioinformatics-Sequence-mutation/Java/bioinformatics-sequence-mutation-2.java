import java.util.Arrays;
import java.util.Random;

public class SequenceMutation {
    public static void main(String[] args) {
        SequenceMutation sm = new SequenceMutation();
        sm.setWeight(OP_CHANGE, 3);
        String sequence = sm.generateSequence(250);
        System.out.println("Initial sequence:");
        printSequence(sequence);
        int count = 10;
        for (int i = 0; i < count; ++i)
            sequence = sm.mutateSequence(sequence);
        System.out.println("After " + count + " mutations:");
        printSequence(sequence);
    }

    public SequenceMutation() {
        totalWeight_ = OP_COUNT;
        Arrays.fill(operationWeight_, 1);
    }

    public String generateSequence(int length) {
        char[] ch = new char[length];
        for (int i = 0; i < length; ++i)
            ch[i] = getRandomBase();
        return new String(ch);
    }

    public void setWeight(int operation, int weight) {
        totalWeight_ -= operationWeight_[operation];
        operationWeight_[operation] = weight;
        totalWeight_ += weight;
    }

    public String mutateSequence(String sequence) {
        char[] ch = sequence.toCharArray();
        int pos = random_.nextInt(ch.length);
        int operation = getRandomOperation();
        if (operation == OP_CHANGE) {
            char b = getRandomBase();
            System.out.println("Change base at position " + pos + " from "
                               + ch[pos] + " to " + b);
            ch[pos] = b;
        } else if (operation == OP_ERASE) {
            System.out.println("Erase base " + ch[pos] + " at position " + pos);
            char[] newCh = new char[ch.length - 1];
            System.arraycopy(ch, 0, newCh, 0, pos);
            System.arraycopy(ch, pos + 1, newCh, pos, ch.length - pos - 1);
            ch = newCh;
        } else if (operation == OP_INSERT) {
            char b = getRandomBase();
            System.out.println("Insert base " + b + " at position " + pos);
            char[] newCh = new char[ch.length + 1];
            System.arraycopy(ch, 0, newCh, 0, pos);
            System.arraycopy(ch, pos, newCh, pos + 1, ch.length - pos);
            newCh[pos] = b;
            ch = newCh;
        }
        return new String(ch);
    }

    public static void printSequence(String sequence) {
        int[] count = new int[BASES.length];
        for (int i = 0, n = sequence.length(); i < n; ++i) {
            if (i % 50 == 0) {
                if (i != 0)
                    System.out.println();
                System.out.printf("%3d: ", i);
            }
            char ch = sequence.charAt(i);
            System.out.print(ch);
            for (int j = 0; j < BASES.length; ++j) {
                if (BASES[j] == ch) {
                    ++count[j];
                    break;
                }
            }
        }
        System.out.println();
        System.out.println("Base counts:");
        int total = 0;
        for (int j = 0; j < BASES.length; ++j) {
            total += count[j];
            System.out.print(BASES[j] + ": " + count[j] + ", ");
        }
        System.out.println("Total: " + total);
    }

    private char getRandomBase() {
        return BASES[random_.nextInt(BASES.length)];
    }

    private int getRandomOperation() {
        int n = random_.nextInt(totalWeight_), op = 0;
        for (int weight = 0; op < OP_COUNT; ++op) {
            weight += operationWeight_[op];
            if (n < weight)
                break;
        }
        return op;
    }

    private final Random random_ = new Random();
    private int[] operationWeight_ = new int[OP_COUNT];
    private int totalWeight_ = 0;

    private static final int OP_CHANGE = 0;
    private static final int OP_ERASE = 1;
    private static final int OP_INSERT = 2;
    private static final int OP_COUNT = 3;
    private static final char[] BASES = {'A', 'C', 'G', 'T'};
}
