        >>SOURCE FORMAT FREE
*> This code is dedicated to the public domain
*> This is GNUCOBOL 2.0
identification division.
program-id. heapsort.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
01  filler.
    03  a pic 99.
    03  a-start pic 99.
    03  a-end pic 99.
    03  a-parent pic 99.
    03  a-child pic 99.
    03  a-sibling pic 99.
    03  a-lim pic 99 value 10.
    03  array-swap pic 99.
    03  array occurs 10 pic 99.
procedure division.
start-heapsort.

    *> fill the array
    compute a = random(seconds-past-midnight)
    perform varying a from 1 by 1 until a > a-lim
        compute array(a) = random() * 100
    end-perform

    perform display-array
    display  space 'initial array'

    *>heapify the array
    move a-lim to a-end
    compute a-start = (a-lim + 1) / 2
    perform sift-down varying a-start from a-start by -1 until a-start = 0

    perform display-array
    display space 'heapified'

    *> sort the array
    move 1 to a-start
    move a-lim to a-end
    perform until a-end = a-start
        move array(a-end) to array-swap
        move array(a-start) to array(a-end)
        move array-swap to array(a-start)
        subtract 1 from a-end
        perform sift-down
    end-perform

    perform display-array
    display space 'sorted'

    stop run
    .
sift-down.
    move a-start to a-parent
    perform until a-parent * 2 > a-end
        compute a-child = a-parent * 2
        compute a-sibling = a-child + 1
        if a-sibling <= a-end and array(a-child) < array(a-sibling)
            *> take the greater of the two
            move a-sibling to a-child
        end-if
        if a-child <= a-end and array(a-parent) < array(a-child)
           *> the child is greater than the parent
           move array(a-child) to array-swap
           move array(a-parent) to array(a-child)
           move array-swap to array(a-parent)
        end-if
        *> continue down the tree
        move a-child to a-parent
    end-perform
    .
display-array.
    perform varying a from 1 by 1 until a > a-lim
        display space array(a) with no advancing
    end-perform
    .
end program heapsort.
