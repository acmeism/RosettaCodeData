identification division.
program-id. subleq-program.
data division.
working-storage section.
01  subleq-source-code.
    05 source-string                      pic x(2000).
01  subleq-virtual-machine.
    05 memory-table.
        10 memory                         pic s9999
            occurs 500 times.
    05 a                                  pic s9999.
    05 b                                  pic s9999.
    05 c                                  pic s9999.
    05 instruction-pointer                pic s9999.
    05 input-output-character             pic x.
01  working-variables.
    05 loop-counter                       pic 9999.
    05 instruction-counter                pic 9999.
    05 string-pointer                     pic 9999.
    05 adjusted-index-a                   pic 9999.
    05 adjusted-index-b                   pic 9999.
    05 output-character-code              pic 9999.
procedure division.
read-source-paragraph.
    accept source-string from console.
    display 'READING SUBLEQ PROGRAM... ' with no advancing.
    move 1 to string-pointer.
    move 0 to instruction-counter.
    perform split-source-paragraph varying loop-counter from 1 by 1
        until loop-counter is greater than 500
        or string-pointer is greater than 2000.
    display instruction-counter with no advancing.
    display ' WORDS READ.'.
execute-paragraph.
    move 1 to instruction-pointer.
    move 0 to instruction-counter.
    display 'BEGINNING RUN... '.
    display ''.
    perform execute-instruction-paragraph
        until instruction-pointer is negative.
    display ''.
    display 'HALTED AFTER ' instruction-counter ' INSTRUCTIONS.'.
    stop run.
execute-instruction-paragraph.
    add 1 to instruction-counter.
    move memory(instruction-pointer) to a.
    add 1 to instruction-pointer.
    move memory(instruction-pointer) to b.
    add 1 to instruction-pointer.
    move memory(instruction-pointer) to c.
    add 1 to instruction-pointer.
    if a is equal to -1 then perform input-paragraph.
    if b is equal to -1 then perform output-paragraph.
    if a is not equal to -1 and b is not equal to -1
        then perform subtraction-paragraph.
split-source-paragraph.
    unstring source-string delimited by all spaces
        into memory(loop-counter)
        with pointer string-pointer.
    add 1 to instruction-counter.
input-paragraph.
    display '> ' with no advancing.
    accept input-output-character from console.
    add 1 to b giving adjusted-index-b.
    move function ord(input-output-character)
        to memory(adjusted-index-b).
    subtract 1 from memory(adjusted-index-b).
output-paragraph.
    add 1 to a giving adjusted-index-a.
    add 1 to memory(adjusted-index-a) giving output-character-code.
    move function char(output-character-code)
        to input-output-character.
    display input-output-character with no advancing.
subtraction-paragraph.
    add 1 to c.
    add 1 to a giving adjusted-index-a.
    add 1 to b giving adjusted-index-b.
    subtract memory(adjusted-index-a) from memory(adjusted-index-b).
    if memory(adjusted-index-b) is equal to zero
        or memory(adjusted-index-b) is negative
        then move c to instruction-pointer.
