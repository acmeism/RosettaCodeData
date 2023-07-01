"""Computer/zero Assembly emulator. Requires Python >= 3.7"""

import re

from typing import Dict
from typing import Iterable
from typing import List
from typing import NamedTuple
from typing import Optional
from typing import Tuple


NOP = 0b000
LDA = 0b001
STA = 0b010
ADD = 0b011
SUB = 0b100
BRZ = 0b101
JMP = 0b110
STP = 0b111

OPCODES = {
    "NOP": NOP,
    "LDA": LDA,
    "STA": STA,
    "ADD": ADD,
    "SUB": SUB,
    "BRZ": BRZ,
    "JMP": JMP,
    "STP": STP,
}

RE_INSTRUCTION = re.compile(
    r"\s*"
    r"(?:(?P<label>\w+):)?"
    r"\s*"
    rf"(?P<opcode>{'|'.join(OPCODES)})?"
    r"\s*"
    r"(?P<argument>\w+)?"
    r"\s*"
    r"(?:;(?P<comment>[\w\s]+))?"
)


class AssemblySyntaxError(Exception):
    pass


class Instruction(NamedTuple):
    label: Optional[str]
    opcode: Optional[str]
    argument: Optional[str]
    comment: Optional[str]


def parse(assembly: str) -> Tuple[List[Instruction], Dict[str, int]]:
    instructions: List[Instruction] = []
    labels: Dict[str, int] = {}
    linenum: int = 0

    for line in assembly.split("\n"):
        match = RE_INSTRUCTION.match(line)

        if not match:
            raise AssemblySyntaxError(f"{line}: {linenum}")

        instructions.append(Instruction(**match.groupdict()))
        label = match.group(1)
        if label:
            labels[label] = linenum

        linenum += 1

    return instructions, labels


def compile(instructions: List[Instruction], labels: Dict[str, int]) -> Iterable[int]:
    for instruction in instructions:
        if instruction.argument is None:
            argument = 0
        elif instruction.argument.isnumeric():
            argument = int(instruction.argument)
        else:
            argument = labels[instruction.argument]

        if instruction.opcode:
            yield OPCODES[instruction.opcode] << 5 | argument
        else:
            yield argument


def run(bytecode: bytes) -> int:
    accumulator = 0
    program_counter = 0
    memory = list(bytecode)[:32] + [0 for _ in range(32 - len(bytecode))]

    while program_counter < 32:
        operation = memory[program_counter] >> 5
        argument = memory[program_counter] & 0b11111
        program_counter += 1

        if operation == NOP:
            continue
        elif operation == LDA:
            accumulator = memory[argument]
        elif operation == STA:
            memory[argument] = accumulator
        elif operation == ADD:
            accumulator = (accumulator + memory[argument]) % 256
        elif operation == SUB:
            accumulator = (accumulator - memory[argument]) % 256
        elif operation == BRZ:
            if accumulator == 0:
                program_counter = argument
        elif operation == JMP:
            program_counter = argument
        elif operation == STP:
            break
        else:
            raise Exception(f"error: {operation} {argument}")

    return accumulator


SAMPLES = [
    """\
            LDA   x
            ADD   y       ; accumulator = x + y
            STP
    x:            2
    y:            2
    """,
    """\
    loop:   LDA   prodt
            ADD   x
            STA   prodt
            LDA   y
            SUB   one
            STA   y
            BRZ   done
            JMP   loop
    done:   LDA   prodt   ; to display it
            STP
    x:            8
    y:            7
    prodt:        0
    one:          1
    """,
    """\
    loop:   LDA   n
            STA   temp
            ADD   m
            STA   n
            LDA   temp
            STA   m
            LDA   count
            SUB   one
            BRZ   done
            STA   count
            JMP   loop
    done:   LDA   n       ; to display it
            STP
    m:            1
    n:            1
    temp:         0
    count:        8       ; valid range: 1-11
    one:          1
    """,
    """\
    start:  LDA   load
            ADD   car     ; head of list
            STA   ldcar
            ADD   one
            STA   ldcdr   ; next CONS cell
    ldcar:  NOP
            STA   value
    ldcdr:  NOP
            BRZ   done    ; 0 stands for NIL
            STA   car
            JMP   start
    done:   LDA   value   ; CAR of last CONS
            STP
    load:   LDA   0
    value:        0
    car:          28
    one:          1
                        ; order of CONS cells
                        ; in memory
                        ; does not matter
                6
                0       ; 0 stands for NIL
                2       ; (CADR ls)
                26      ; (CDDR ls) -- etc.
                5
                20
                3
                30
                1       ; value of (CAR ls)
                22      ; points to (CDR ls)
                4
                24
    """,
    """\
    p:            0       ; NOP in first round
    c:            0
    start:  STP           ; wait for p's move
    pmove:  NOP
            LDA   pmove
            SUB   cmove
            BRZ   same
            LDA   pmove
            STA   cmove   ; tit for tat
            BRZ   cdeft
            LDA   c       ; p defected, c did not
            ADD   three
            STA   c
            JMP   start
    cdeft:  LDA   p
            ADD   three
            STA   p
            JMP   start
    same:   LDA   pmove
            STA   cmove   ; tit for tat
            LDA   p
            ADD   one
            ADD   pmove
            STA   p
            LDA   c
            ADD   one
            ADD   pmove
            STA   c
            JMP   start
    cmove:        0       ; co-operate initially
    one:          1
    three:        3
    """,
    """\
    LDA  3
    SUB  4
    STP  0
         0
         255
    """,
    """\
    LDA  3
    SUB  4
    STP  0
         0
         1
    """,
    """\
    LDA  3
    ADD  4
    STP  0
         1
         255
    """,
]


def main() -> None:
    for sample in SAMPLES:
        instructions, labels = parse(sample)
        bytecode = bytes(compile(instructions, labels))
        result = run(bytecode)
        print(result)


if __name__ == "__main__":
    main()
