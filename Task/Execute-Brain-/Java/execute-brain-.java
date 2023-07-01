import java.io.IOException;

public class Interpreter {

    public final static int MEMORY_SIZE = 65536;

    private final char[] memory = new char[MEMORY_SIZE];
    private int dp;
    private int ip;
    private int border;

    private void reset() {

        for (int i = 0; i < MEMORY_SIZE; i++) {
            memory[i] = 0;
        }
        ip = 0;
        dp = 0;
    }

    private void load(String program) {

        if (program.length() > MEMORY_SIZE - 2) {
            throw new RuntimeException("Not enough memory.");
        }

        reset();

        for (; dp < program.length(); dp++) {
            memory[dp] = program.charAt(dp);
        }

        // memory[border] = 0 marks the end of instructions. dp (data pointer) cannot move lower than the
        // border into the program area.
        border = dp;

        dp += 1;
    }

    public void execute(String program) {

        load(program);
        char instruction = memory[ip];

        while (instruction != 0) {

            switch (instruction) {
                case '>':
                    dp++;
                    if (dp == MEMORY_SIZE) {
                        throw new RuntimeException("Out of memory.");
                    }
                    break;
                case '<':
                    dp--;
                    if (dp == border) {
                        throw new RuntimeException("Invalid data pointer.");
                    }
                    break;
                case '+':
                    memory[dp]++;
                    break;
                case '-':
                    memory[dp]--;
                    break;
                case '.':
                    System.out.print(memory[dp]);
                    break;
                case ',':
                    try {
                        // Only works for one byte characters.
                        memory[dp] = (char) System.in.read();
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                    break;
                case '[':
                    if (memory[dp] == 0) {
                        skipLoop();
                    }
                    break;
                case ']':
                    if (memory[dp] != 0) {
                        loop();
                    }
                    break;
                default:
                    throw new RuntimeException("Unknown instruction.");
            }

            instruction = memory[++ip];
        }
    }

    private void skipLoop() {

        int loopCount = 0;

        while (memory[ip] != 0) {
            if (memory[ip] == '[') {
                loopCount++;
            } else if (memory[ip] == ']') {
                loopCount--;
                if (loopCount == 0) {
                    return;
                }
            }
            ip++;
        }

        if (memory[ip] == 0) {
            throw new RuntimeException("Unable to find a matching ']'.");
        }
    }

    private void loop() {

        int loopCount = 0;

        while (ip >= 0) {
            if (memory[ip] == ']') {
                loopCount++;
            } else if (memory[ip] == '[') {
                loopCount--;
                if (loopCount == 0) {
                    return;
                }
            }
            ip--;
        }

        if (ip == -1) {
            throw new RuntimeException("Unable to find a matching '['.");
        }
    }

    public static void main(String[] args) {

        Interpreter interpreter = new Interpreter();
        interpreter.execute(">++++++++[-<+++++++++>]<.>>+>-[+]++>++>+++[>[->+++<<+++>]<<]>-----.>->+++..+++.>-.<<+[>[+>+]>>]<--------------.>>.+++.------.--------.>+.>+.");
    }
}
