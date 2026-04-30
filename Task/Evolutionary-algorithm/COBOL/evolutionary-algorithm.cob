identification division.
program-id. evolutionary-program.
data division.
working-storage section.
01  evolving-strings.
    05 target                pic a(28)
        value 'METHINKS IT IS LIKE A WEASEL'.
    05 parent                pic a(28).
    05 offspring-table.
        10 offspring         pic a(28)
            occurs 50 times.
01  fitness-calculations.
    05 fitness               pic 99.
    05 highest-fitness       pic 99.
    05 fittest               pic 99.
01  parameters.
    05 character-set         pic a(27)
        value 'ABCDEFGHIJKLMNOPQRSTUVWXYZ '.
    05 size-of-generation    pic 99
        value 50.
    05 mutation-rate         pic 99
        value 5.
01  counters-and-working-variables.
    05 character-position    pic 99.
    05 randomization.
        10 random-seed       pic 9(8).
        10 random-number     pic 99.
        10 random-letter     pic 99.
    05 generation            pic 999.
    05 child                 pic 99.
    05 temporary-string      pic a(28).
procedure division.
control-paragraph.
    accept random-seed from time.
    move function random(random-seed) to random-number.
    perform random-letter-paragraph,
    varying character-position from 1 by 1
    until character-position is greater than 28.
    move temporary-string to parent.
    move zero to generation.
    perform output-paragraph.
    perform evolution-paragraph,
    varying generation from 1 by 1
    until parent is equal to target.
    stop run.
evolution-paragraph.
    perform mutation-paragraph varying child from 1 by 1
    until child is greater than size-of-generation.
    move zero to highest-fitness.
    move 1 to fittest.
    perform check-fitness-paragraph varying child from 1 by 1
    until child is greater than size-of-generation.
    move offspring(fittest) to parent.
    perform output-paragraph.
output-paragraph.
    display generation ': ' parent.
random-letter-paragraph.
    move function random to random-number.
    divide random-number by 3.80769 giving random-letter.
    add 1 to random-letter.
    move character-set(random-letter:1)
    to temporary-string(character-position:1).
mutation-paragraph.
    move parent to temporary-string.
    perform character-mutation-paragraph,
    varying character-position from 1 by 1
    until character-position is greater than 28.
    move temporary-string to offspring(child).
character-mutation-paragraph.
    move function random to random-number.
    if random-number is less than mutation-rate
    then perform random-letter-paragraph.
check-fitness-paragraph.
    move offspring(child) to temporary-string.
    perform fitness-paragraph.
fitness-paragraph.
    move zero to fitness.
    perform character-fitness-paragraph,
    varying character-position from 1 by 1
    until character-position is greater than 28.
    if fitness is greater than highest-fitness
    then perform fittest-paragraph.
character-fitness-paragraph.
    if temporary-string(character-position:1) is equal to
    target(character-position:1) then add 1 to fitness.
fittest-paragraph.
    move fitness to highest-fitness.
    move child to fittest.
