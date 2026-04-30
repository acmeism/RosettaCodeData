class Subleq {
    static main() {
        const mem = [
            15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1,
            15, 15, 0, 0, -1, 72, 101, 108, 108, 111, 44, 32,
            119, 111, 114, 108, 100, 33, 10, 0
        ];
        const readline = require('readline').createInterface({
            input: process.stdin,
            output: process.stdout
        });

        let instructionPointer = 0;
        const loop = () => {
            const a = mem[instructionPointer];
            const b = mem[instructionPointer + 1];

            if (a === -1) {
                readline.question('', (input) => {
                    mem[b] = parseInt(input, 10);
                    instructionPointer += 3;
                    loop();
                });
            } else if (b === -1) {
                process.stdout.write(String.fromCharCode(mem[a]));
                instructionPointer += 3;
                loop();
            } else {
                mem[b] -= mem[a];
                if (mem[b] < 1) {
                    instructionPointer = mem[instructionPointer + 2];
                } else {
                    instructionPointer += 3;
                }
                loop();
            }
        };
        loop();
    }
}

// Run the main function
Subleq.main();
