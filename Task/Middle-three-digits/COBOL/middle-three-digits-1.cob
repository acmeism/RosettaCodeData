identification division.
program-id. middle3.
environment division.
data division.
working-storage section.
01  num                 pic 9(9).
    88 num-too-small    values are -99 thru 99.
01  num-disp            pic ---------9.

01  div                 pic 9(9).
01  mod                 pic 9(9).
01  mod-disp            pic 9(3).

01  digit-counter       pic 999.
01  digit-div           pic 9(9).
    88  no-more-digits  value 0.
01  digit-mod           pic 9(9).
    88  is-even         value 0.

01  multiplier          pic 9(9).

01  value-items.
    05  filler  pic s9(9) value 123.
    05  filler  pic s9(9) value 12345.
    05  filler  pic s9(9) value 1234567.
    05  filler  pic s9(9) value 987654321.
    05  filler  pic s9(9) value 10001.
    05  filler  pic s9(9) value -10001.
    05  filler  pic s9(9) value -123.
    05  filler  pic s9(9) value -100.
    05  filler  pic s9(9) value 100.
    05  filler  pic s9(9) value -12345.
    05  filler  pic s9(9) value 1.
    05  filler  pic s9(9) value 2.
    05  filler  pic s9(9) value -1.
    05  filler  pic s9(9) value -10.
    05  filler  pic s9(9) value 2002.
    05  filler  pic s9(9) value -2002.
    05  filler  pic s9(9) value 0.

01  value-array redefines value-items.
    05  items   pic s9(9)  occurs 17 times indexed by item.

01  result  pic x(20).

procedure division.
10-main.
    perform with test after varying item from 1 by 1 until items(item) = 0
        move items(item) to num
        move items(item) to num-disp
        perform 20-check
        display num-disp " --> " result
    end-perform.
    stop run.

20-check.
    if num-too-small
        move "Number too small" to result
        exit paragraph
    end-if.

    perform 30-count-digits.
    divide digit-counter by 2 giving digit-div remainder digit-mod.
    if is-even
        move "Even number of digits" to result
        exit paragraph
    end-if.

    *> if digit-counter is 5, mul by 10
    *> if digit-counter is 7, mul by 100
    *> if digit-counter is 9, mul by 1000

    if digit-counter > 3
        compute multiplier rounded = 10 ** (((digit-counter - 5) / 2) + 1)
        divide num by multiplier giving num
        divide num by 1000 giving div remainder mod
        move mod to mod-disp
    else
        move num to mod-disp
    end-if.
    move mod-disp to result.
    exit paragraph.

30-count-digits.
    move zeroes to digit-counter.
    move num to digit-div.
    perform with test before until no-more-digits
        divide digit-div by 10 giving digit-div remainder digit-mod
        add 1 to digit-counter
    end-perform.
    exit paragraph.
