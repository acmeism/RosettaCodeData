import sys
from collections import deque
from itertools import repeat


def interpret(instructions: str, memory_size: int, eof: int | None = None) -> None:

    jump_table: dict[int, int] = {}

    def jump(ip: int) -> int:
        if ip in jump_table:
            return jump_table[ip]

        if instructions[ip] == "[":
            depth = 0
            for i in range(ip, len(instructions)):
                if instructions[i] == "[":
                    depth += 1
                elif instructions[i] == "]":
                    depth -= 1
                    if depth == 0:
                        jump_table[ip] = i
                        jump_table[i] = ip
                        return i

        elif instructions[ip] == "]":
            depth = 0
            for i in range(ip, -1, -1):
                if instructions[i] == "]":
                    depth += 1
                elif instructions[i] == "[":
                    depth -= 1
                    if depth == 0:
                        jump_table[ip] = i
                        jump_table[i] = ip
                        return i

        raise Exception("unbalanced brackets")

    tape = deque(repeat(0, memory_size), memory_size)
    ip = 0

    while ip < len(instructions):
        op = instructions[ip]

        if op == ">":
            tape.rotate(-1)
        elif op == "<":
            tape.rotate()
        elif op == "+":
            tape[0] += 1
        elif op == "-":
            tape[0] -= 1
        elif op == ",":
            if ch := sys.stdin.read(1):
                tape[0] = ord(ch)
            elif eof is not None:
                tape[0] = eof
        elif op == ".":
            sys.stdout.write(chr(tape[0]))
        elif op == "[" and not tape[0]:
            ip = jump(ip)
        elif op == "]" and tape[0]:
            ip = jump(ip)

        ip += 1


if __name__ == "__main__":
    prog = "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
    interpret(prog, 10)
