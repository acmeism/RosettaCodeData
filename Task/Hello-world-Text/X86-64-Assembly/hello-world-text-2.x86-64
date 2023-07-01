// No "main" used
// compile with `gcc -nostdlib`
#define SYS_WRITE   $1
#define STDOUT      $1
#define SYS_EXIT    $60
#define MSGLEN      $14

.global _start
.text

_start:
    movq    $message, %rsi          // char *
    movq    SYS_WRITE, %rax
    movq    STDOUT, %rdi
    movq    MSGLEN, %rdx
    syscall                         // sys_write(message, stdout, 0x14);

    movq    SYS_EXIT, %rax
    xorq    %rdi, %rdi              // The exit code.
    syscall                         // exit(0)

.data
message:    .ascii "Hello, world!\n"
