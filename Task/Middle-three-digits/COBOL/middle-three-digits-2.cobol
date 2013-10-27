identification division.
program-id. middle3.
environment division.
data division.
working-storage section.
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

01 value-array redefines value-items.
        05  items   pic s9(9)  occurs 17 times indexed by item.

01 num      pic 9(9).
01 num-disp pic ---------9.
01 num2     pic 9(9).

01 power    pic 9.
01 power10  pic 9(16).

01 three-digits pic 999.

01 result   pic X(20).

01 flag     pic 9.
    88 done value 1.

procedure division.
01-setup.
    perform 02-outer with test after varying item from 1 by 1 until items(item) = 0.
    stop run.

02-outer.
    move items(item) to num.
    move items(item) to num-disp.
    if num less than 100
        move "too small" to result
    else
        perform 03-inner with test after varying power from 9 by -1 until power = 1 or done
    end-if.
    display num-disp " --> " result.
    exit paragraph.

03-inner.
    move 0 to flag.
    compute power10 = 10 ** power.
    if num >= power10
        move 1 to flag
        if function mod(power,2) = 1
            move "even number digits" to result
        else
            move num to num2
            compute num2 = num2 / ( 10 ** (( power / 2 ) - 1 ))
            move function mod(num2,1000) to three-digits
            move three-digits to result
        end-if
    end-if.
