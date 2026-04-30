        >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCOBOL 2.0
identification division.
program-id. insertionsort.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  filler.
    03  a pic 99.
    03  a-lim pic 99 value 10.
    03  array occurs 10 pic 99.

01  filler.
    03  s pic 99.
    03  o pic 99.
    03  o1 pic 99.
    03  sorted-len pic 99.
    03  sorted-lim pic 99 value 10.
    03  sorted-array occurs 10 pic 99.

procedure division.
start-insertionsort.

    *> fill the array
    compute a = random(seconds-past-midnight)
    perform varying a from 1 by 1 until a > a-lim
        compute array(a) = random() * 100
    end-perform

    *> display the array
    perform varying a from 1 by 1 until a > a-lim
        display space array(a) with no advancing
    end-perform
    display  space 'initial array'

    *> sort the array
    move 0 to sorted-len
    perform varying a from 1 by 1 until a > a-lim
        *> find the insertion point
        perform varying s from 1 by 1
        until s > sorted-len
        or array(a) <= sorted-array(s)
            continue
        end-perform

        *>open the insertion point
        perform varying o from sorted-len by -1
        until o < s
            compute o1 = o + 1
            move sorted-array(o) to sorted-array(o1)
        end-perform

        *> move the array-entry to the insertion point
        move array(a) to sorted-array(s)

        add 1 to sorted-len
    end-perform

    *> display the sorted array
    perform varying s from 1 by 1 until s > sorted-lim
        display space sorted-array(s) with no advancing
    end-perform
    display space 'sorted array'

    stop run
    .
end program insertionsort.
