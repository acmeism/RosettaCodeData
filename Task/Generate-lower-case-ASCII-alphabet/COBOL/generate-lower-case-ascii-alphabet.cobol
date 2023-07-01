identification division.
program-id. lower-case-alphabet-program.
data division.
working-storage section.
01  ascii-lower-case.
    05 lower-case-alphabet pic a(26).
    05 character-code      pic 999.
    05 loop-counter        pic 99.
procedure division.
control-paragraph.
    perform add-next-letter-paragraph varying loop-counter from 1 by 1
    until loop-counter is greater than 26.
    display lower-case-alphabet upon console.
    stop run.
add-next-letter-paragraph.
    add 97 to loop-counter giving character-code.
    move function char(character-code) to lower-case-alphabet(loop-counter:1).
