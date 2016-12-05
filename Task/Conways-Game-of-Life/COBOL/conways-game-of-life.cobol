identification division.
program-id. game-of-life-program.
data division.
working-storage section.
01  grid.
    05 cell-table.
        10 row occurs 5 times.
            15 cell pic x value space occurs 5 times.
    05 next-gen-cell-table.
        10 next-gen-row occurs 5 times.
            15 next-gen-cell pic x occurs 5 times.
01  counters.
    05 generation pic 9.
    05 current-row pic 9.
    05 current-cell pic 9.
    05 living-neighbours pic 9.
    05 neighbour-row pic 9.
    05 neighbour-cell pic 9.
    05 check-row pic s9.
    05 check-cell pic s9.
procedure division.
control-paragraph.
    perform blinker-paragraph varying current-cell from 2 by 1
    until current-cell is greater than 4.
    perform show-grid-paragraph through life-paragraph
    varying generation from 0 by 1
    until generation is greater than 2.
    stop run.
blinker-paragraph.
    move '#' to cell(3,current-cell).
show-grid-paragraph.
    display 'GENERATION ' generation ':'.
    display '   +---+'.
    perform show-row-paragraph varying current-row from 2 by 1
    until current-row is greater than 4.
    display '   +---+'.
    display ''.
life-paragraph.
    perform update-row-paragraph varying current-row from 2 by 1
    until current-row is greater than 4.
    move next-gen-cell-table to cell-table.
show-row-paragraph.
    display '   |' with no advancing.
    perform show-cell-paragraph varying current-cell from 2 by 1
    until current-cell is greater than 4.
    display '|'.
show-cell-paragraph.
    display cell(current-row,current-cell) with no advancing.
update-row-paragraph.
    perform update-cell-paragraph varying current-cell from 2 by 1
    until current-cell is greater than 4.
update-cell-paragraph.
    move 0 to living-neighbours.
    perform check-row-paragraph varying check-row from -1 by 1
    until check-row is greater than 1.
    evaluate living-neighbours,
        when 2 move cell(current-row,current-cell) to next-gen-cell(current-row,current-cell),
        when 3 move '#' to next-gen-cell(current-row,current-cell),
        when other move space to next-gen-cell(current-row,current-cell),
    end-evaluate.
check-row-paragraph.
    add check-row to current-row giving neighbour-row.
    perform check-cell-paragraph varying check-cell from -1 by 1
    until check-cell is greater than 1.
check-cell-paragraph.
    add check-cell to current-cell giving neighbour-cell.
    if cell(neighbour-row,neighbour-cell) is equal to '#',
    and check-cell is not equal to zero or check-row is not equal to zero,
    then add 1 to living-neighbours.
