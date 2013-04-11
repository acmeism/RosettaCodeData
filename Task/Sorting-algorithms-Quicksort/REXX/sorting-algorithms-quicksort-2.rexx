    a = '4 65 2 -31 0 99 83 782 1'
    do i = 1 to words(a)
        queue word(a, i)
    end
    call quickSort
    parse pull item
    do queued()
        call charout ,item', '
        parse pull item
    end
    say item
    exit

quickSort: procedure
/* In classic Rexx, arguments are passed by value, not by reference so stems
    cannot be passed as arguments nor used as return values.  Putting their
    contents on the external data queue is a way to bypass this issue. */

    /* construct the input stem */
    arr.0 = queued()
    do i = 1 to arr.0
        parse pull arr.i
    end
    less.0 = 0
    pivotList.0 = 0
    more.0 = 0
    if arr.0 <= 1 then do
        if arr.0 = 1 then
            queue arr.1
        return
    end
    else do
        pivot = arr.1
        do i = 1 to arr.0
            item = arr.i
            select
                when item < pivot then do
                    j = less.0 + 1
                    less.j = item
                    less.0 = j
                end
                when item > pivot then do
                    j = more.0 + 1
                    more.j = item
                    more.0 = j
                end
                otherwise
                    j = pivotList.0 + 1
                    pivotList.j = item
                    pivotList.0 = j
            end
        end
    end
    /* recursive call to sort the less. stem */
    do i = 1 to less.0
        queue less.i
    end
    if queued() > 0 then do
        call quickSort
        less.0 = queued()
        do i = 1 to less.0
            parse pull less.i
        end
    end
    /* recursive call to sort the more. stem */
    do i = 1 to more.0
        queue more.i
    end
    if queued() > 0 then do
        call quickSort
        more.0 = queued()
        do i = 1 to more.0
            parse pull more.i
        end
    end
    /* put the contents of all 3 stems on the queue in order */
    do i = 1 to less.0
        queue less.i
    end
    do i = 1 to pivotList.0
        queue pivotList.i
    end
    do i = 1 to more.0
        queue more.i
    end
    return
