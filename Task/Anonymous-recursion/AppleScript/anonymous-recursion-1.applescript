on fibonacci(n) -- "Anonymous recursion" task.
    -- For the sake of the task, a needlessly anonymous local script object containing a needlessly recursive handler.
    -- The script could easily (and ideally should) be assigned to a local variable.
    script
        property one : 1
        property sequence : {}
 
        on f(n)
            if (n < 2) then
                set end of my sequence to 0
                if (n is 1) then set end of my sequence to one
            else
                f(n - 1)
                set end of my sequence to (item -2 of my sequence) + (end of my sequence)
            end if
        end f
    end script
 
    -- Don't insert any additional code here!
 
    -- Sort out whether the input's positive or negative and tell the object generated above to do the recursive business.
    tell result
        if (n < 0) then
            set its one to -1
            set n to -n
        end if
        f(n)
 
        return its sequence
    end tell
end fibonacci
 
fibonacci(15) --> {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610}
fibonacci(-15) --> {0, -1, -1, -2, -3, -5, -8, -13, -21, -34, -55, -89, -144, -233, -377, -610}
