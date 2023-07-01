global i

on recursion()
    set i to i + 1
    recursion()
end recursion

on run
    set i to -1
    try
        recursion()
    on error
        "Recursion limit encountered at " & i
        -- display dialog result -- Uncomment to see the result if running as an applet.
    end try
end run
