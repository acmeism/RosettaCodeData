class BrainfuckProgram {

    def program = '', memory = [:]
    def instructionPointer = 0, dataPointer = 0

    def execute() {
        while (instructionPointer < program.size())
            switch(program[instructionPointer++]) {
            case '>': dataPointer++; break;
            case '<': dataPointer--; break;
            case '+': memory[dataPointer] = memoryValue + 1; break
            case '-': memory[dataPointer] = memoryValue - 1; break
            case ',': memory[dataPointer] = System.in.read(); break
            case '.': print String.valueOf(Character.toChars(memoryValue)); break
            case '[': handleLoopStart(); break
            case ']': handleLoopEnd(); break
            }
    }

    private getMemoryValue() { memory[dataPointer] ?: 0 }

    private handleLoopStart() {
        if (memoryValue) return

        int depth = 1
        while (instructionPointer < program.size())
            switch(program[instructionPointer++]) {
            case '[': depth++; break
            case ']': if (!(--depth)) return
            }
        throw new IllegalStateException('Could not find matching end bracket')
    }

    private handleLoopEnd() {
        int depth = 0
        while (instructionPointer >= 0) {
            switch(program[--instructionPointer]) {
            case ']': depth++; break
            case '[': if (!(--depth)) return; break
            }
        }
        throw new IllegalStateException('Could not find matching start bracket')
    }
}
