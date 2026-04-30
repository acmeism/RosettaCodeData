         >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCOBOL 2.0
identification division.
program-id. fifteen.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.

01  r pic 9.
01  r-empty pic 9.
01  r-to pic 9.
01  r-from pic 9.

01  c pic 9.
01  c-empty pic 9.
01  c-to pic 9.
01  c-from pic 9.

01  display-table.
    03  display-row occurs 4.
        05  display-cell occurs 4 pic 99.

01  tile-number pic 99.
01  tile-flags pic x(16).

01  display-move value spaces.
    03  tile-id pic 99.

01  row-separator pic x(21) value all '.'.
01  column-separator pic x(3) value ' . '.

01  inversions pic 99.
01  current-tile pic 99.

01  winning-display pic x(32) value
        '01020304'
    &   '05060708'
    &   '09101112'
    &   '13141500'.

procedure division.
start-fifteen.
    display 'start fifteen puzzle'
    display '    enter a two-digit tile number and press <enter> to move'
    display '    press <enter> only to exit'

    *> tables with an odd number of inversions are not solvable
    perform initialize-table with test after until inversions = 0
    perform show-table
    accept display-move
    perform until display-move = spaces
        perform move-tile
        perform show-table
        move spaces to display-move
        accept display-move
    end-perform
    stop run
    .
initialize-table.
    compute tile-number = random(seconds-past-midnight) *> seed only
    move spaces to tile-flags
    move 0 to current-tile inversions
    perform varying r from 1 by 1 until r > 4
    after c from 1 by 1 until c > 4
        perform with test after
        until tile-flags(tile-number + 1:1) = space
            compute tile-number = random() * 100
            compute tile-number = mod(tile-number, 16)
        end-perform
        move 'x' to tile-flags(tile-number + 1:1)
        if tile-number > 0 and < current-tile
            add 1 to inversions
        end-if
        move tile-number to display-cell(r,c) current-tile
    end-perform
    compute inversions = mod(inversions,2)
    .
show-table.
    if display-table = winning-display
        display 'winning'
    end-if
    display space row-separator
    perform varying r from 1 by 1 until r > 4
        perform varying c from 1 by 1 until c > 4
            display column-separator with no advancing
            if display-cell(r,c) = 00
                display '  ' with no advancing
                move r to r-empty
                move c to c-empty
            else
                display display-cell(r,c) with no advancing
            end-if
        end-perform
        display column-separator
    end-perform
    display space row-separator
    .
move-tile.
    if not (tile-id numeric and tile-id >= 01 and <= 15)
        display 'invalid tile number'
        exit paragraph
    end-if

    *> find the entered tile-id row and column (r,c)
    perform varying r from 1 by 1 until r > 4
    after c from 1 by 1 until c > 4
        if display-cell(r,c) = tile-id
            exit perform
        end-if
    end-perform

    *> show-table filled (r-empty,c-empty)
    evaluate true
    when r = r-empty
        if c-empty < c
            *> shift left
            perform varying c-to from c-empty by 1 until c-to > c
                compute c-from = c-to + 1
                move display-cell(r-empty,c-from) to display-cell(r-empty,c-to)
            end-perform
        else
           *> shift right
           perform varying c-to from c-empty by -1 until c-to < c
               compute c-from = c-to - 1
               move display-cell(r-empty,c-from) to display-cell(r-empty,c-to)
           end-perform
       end-if
       move 00 to display-cell(r,c)
    when c = c-empty
        if r-empty < r
            *>shift up
            perform varying r-to from r-empty by 1 until r-to > r
                compute r-from = r-to + 1
                move display-cell(r-from,c-empty) to display-cell(r-to,c-empty)
            end-perform
        else
            *> shift down
            perform varying r-to from r-empty by -1 until r-to < r
                compute r-from = r-to - 1
                move display-cell(r-from,c-empty) to display-cell(r-to,c-empty)
            end-perform
        end-if
        move 00 to display-cell(r,c)
    when other
         display 'invalid move'
    end-evaluate
    .
end program fifteen.
