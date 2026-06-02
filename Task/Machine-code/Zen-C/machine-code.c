import "std/sys/mman.zc"
import "std/io.zc"

fn main() {
    let opcodes: byte[5];
    opcodes[0] = 0x89; // mov eax, edi
    opcodes[1] = 0xF8;
    opcodes[2] = 0x01; // add eax, esi
    opcodes[3] = 0xF0;
    opcodes[4] = 0xC3; // ret

    let size: usize = 4096; // Standard page size

    // Map memory as Read / Write
    let addr = Memory::mmap(size, Z_PROT_READ | Z_PROT_WRITE, Z_MAP_PRIVATE | Z_MAP_ANONYMOUS);

    if (isize)addr == Z_MAP_FAILED {
        eprintln "Failed to mmap memory";
        exit(1);
    }

    // Poke the opcodes into the allocated memory
    let ptr = (byte*)addr;
    for i in 0..5 {
        ptr[i] = opcodes[i];
    }

    // Change memory protection to Read / Execute (Preventing W^X violations)
    if !Memory::mprotect(addr, size, Z_PROT_READ | Z_PROT_EXEC) {
        eprintln "Failed to mprotect memory";
        Memory::munmap(addr, size);
        exit(1);
    }

    // Cast the executable memory address to a Zen C raw function pointer
    let add_func: fn* (int, int) -> int = (void*)addr;

    // Execute the machine code
    let a = 7;
    let b = 12;
    let result = add_func(a, b);

    println "Executing machine code (x86_64: mov eax, edi; add eax, esi; ret)";
    println "Arguments: {a}, {b}";
    println "Result: {result}";

    // Clean up
    Memory::munmap(addr, size);

    if result == 19 {
        println "Success!";
    } else {
        eprintln "Failure: expected 19, got {result}";
        exit(1);
    }
}
