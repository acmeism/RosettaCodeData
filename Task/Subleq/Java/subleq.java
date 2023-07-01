import java.util.Scanner;

public class Subleq {

    public static void main(String[] args) {
        int[] mem = {15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0,
            -1, 72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10, 0};

        Scanner input = new Scanner(System.in);
        int instructionPointer = 0;

        do {
            int a = mem[instructionPointer];
            int b = mem[instructionPointer + 1];

            if (a == -1) {
                mem[b] = input.nextInt();

            } else if (b == -1) {
                System.out.printf("%c", (char) mem[a]);

            } else {

                mem[b] -= mem[a];
                if (mem[b] < 1) {
                    instructionPointer = mem[instructionPointer + 2];
                    continue;
                }
            }

            instructionPointer += 3;

        } while (instructionPointer >= 0);
    }
}
