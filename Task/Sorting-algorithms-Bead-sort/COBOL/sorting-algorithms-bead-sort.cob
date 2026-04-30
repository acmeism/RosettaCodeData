        >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCOBOL 2.0
identification division.
program-id. beadsort.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  filler.
    03  row occurs 9 pic x(9).
    03  r pic 99.
    03  r1 pic 99.
    03  r2 pic 99.
    03  pole pic 99.
    03  a-lim pic 99 value 9.
    03  a pic 99.
    03  array occurs 9 pic 9.
01  NL pic x value x'0A'.
procedure division.
start-beadsort.

    *> fill the array
    compute a = random(seconds-past-midnight)
    perform varying a from 1 by 1 until a > a-lim
        compute array(a) = random() * 10
    end-perform

    perform display-array
    display space 'initial array'

    *> distribute the beads
    perform varying r from 1 by 1 until r > a-lim
        move all '.' to row(r)
        perform varying pole from 1 by 1 until pole > array(r)
            move 'o' to row(r)(pole:1)
        end-perform
    end-perform
    display NL 'initial beads'
    perform display-beads

    *> drop the beads
    perform varying pole from 1 by 1 until pole > a-lim
        move a-lim to r2
        perform find-opening
        compute r1 = r2 - 1
        perform find-bead
        perform until r1 = 0 *> no bead or no opening
            *> drop the bead
            move '.' to row(r1)(pole:1)
            move 'o' to row(r2)(pole:1)
            *> continue up the pole
            compute r2 = r2 - 1
            perform find-opening
            compute r1 = r2 - 1
            perform find-bead
        end-perform
    end-perform
    display NL 'dropped beads'
    perform display-beads

    *> count the beads in each row
    perform varying r from 1 by 1 until r > a-lim
        move 0 to array(r)
        inspect row(r) tallying array(r)
            for all 'o' before initial '.'
    end-perform

    perform display-array
    display space 'sorted array'

    stop run
    .
find-opening.
    perform varying r2 from r2 by -1
    until r2 = 1 or row(r2)(pole:1) = '.'
        continue
    end-perform
    .
find-bead.
    perform varying r1 from r1 by -1
    until r1 = 0 or row(r1)(pole:1) = 'o'
        continue
    end-perform
    .
display-array.
    display space
    perform varying a from 1 by 1 until a > a-lim
        display space array(a) with no advancing
    end-perform
    .
display-beads.
    perform varying r from 1 by 1 until r > a-lim
        display row(r)
    end-perform
    .
end program beadsort.
