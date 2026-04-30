         >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
identification division.
program-id. dragon.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  segment-length pic 9 value 2.
01  mark pic x value '.'.
01  segment-count pic 9999 value 513.

01  segment pic 9999.
01  point pic 9999 value 1.
01  point-max pic 9999.
01  point-lim pic 9999 value 8192.
01  dragon-curve.
    03  filler occurs 8192.
        05  ydragon pic s9999.
        05  xdragon pic s9999.

01  x pic s9999 value 1.
01  y pic S9999 value 1.

01  xdelta pic s9 value 1. *> start pointing east
01  ydelta pic s9 value 0.

01  x-max pic s9999 value -9999.
01  x-min pic s9999 value 9999.
01  y-max pic s9999 value -9999.
01  y-min pic s9999 value 9999.

01  n pic 9999.
01  r pic 9.

01  xupper pic s9999.
01  yupper pic s9999.

01  window-line-number pic 99.
01  window-width pic 99 value 64.
01  window-height pic 99 value 22.
01  window.
    03  window-line occurs 22.
        05  window-point occurs 64 pic x.

01  direction pic x.

procedure division.
start-dragon.

    if segment-count * segment-length > point-lim
        *> too many segments for the point-table
        compute segment-count = point-lim / segment-length
    end-if

    perform varying segment from 1 by 1
    until segment > segment-count

        *>===========================================
        *> segment = n * 2 ** b
        *> if mod(n,4) = 3, turn left else turn right
        *>===========================================

        *> calculate the turn
        divide 2 into segment giving n remainder r
        perform until r <> 0
            divide 2 into n giving n remainder r
        end-perform
        divide 2 into n giving n remainder r

        *> perform the turn
        evaluate r also xdelta also ydelta
        when 0 also 1 also 0  *> turn right from east
        when 1 also -1 also 0 *> turn left from west
            *> turn to south
            move 0 to xdelta
            move 1 to ydelta
        when 1 also 1 also 0  *> turn left from east
        when 0 also -1 also 0 *> turn right from west
            *> turn to north
            move 0 to xdelta
            move -1 to ydelta
        when 0 also 0 also 1  *> turn right from south
        when 1 also 0 also -1 *> turn left from north
            *> turn to west
            move 0 to ydelta
            move -1 to xdelta
        when 1 also 0 also 1  *> turn left from south
        when 0 also 0 also -1 *> turn right from north
            *> turn to east
            move 0 to ydelta
            move 1 to xdelta
        end-evaluate

        *> plot the segment points
        perform segment-length times
            add xdelta to x
            add ydelta to y

            move x to xdragon(point)
            move y to ydragon(point)

            add 1 to point
        end-perform

        *> update the limits for the display
        compute x-max = max(x, x-max)
        compute x-min = min(x, x-min)
        compute y-max = max(y, y-max)
        compute y-min = min(y, y-min)
        move point to point-max

    end-perform

    *>==========================================
    *> display the curve
    *> hjkl corresponds to left, up, down, right
    *> anything else ends the program
    *>==========================================

    move 1 to yupper xupper

    perform with test after
    until direction <> 'h' and 'j' and 'k' and 'l'

        *>==========================================
        *> (yupper,xupper) maps to window-point(1,1)
        *>==========================================

        *> move the window
        evaluate true
        when direction = 'h' *> move window left
        and xupper > x-min + window-width
           subtract 1 from xupper
        when direction = 'j' *> move window up
        and yupper < y-max - window-height
           add 1 to yupper
        when direction = 'k' *> move window down
        and yupper > y-min + window-height
           subtract 1 from yupper
        when direction = 'l' *> move window right
        and xupper < x-max - window-width
            add 1 to xupper
        end-evaluate

        *> plot the dragon points in the window
        move spaces to window
        perform varying point from 1 by 1
        until point > point-max
            if ydragon(point) >= yupper and < yupper + window-height
            and xdragon(point) >= xupper and < xupper + window-width
                *> we're in the window
                compute y = ydragon(point) - yupper + 1
                compute x =  xdragon(point) - xupper + 1
                move mark to window-point(y, x)
            end-if
         end-perform

         *> display the window
         perform varying window-line-number from 1 by 1
         until window-line-number > window-height
             display window-line(window-line-number)
         end-perform

         *> get the next window move or terminate
         display 'hjkl?' with no advancing
         accept direction
    end-perform

    stop run
    .
end program dragon.
