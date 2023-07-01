func() {
    // 1. statements executed in either case
    // 2. func below is a closure that captures free variables
    //    now, although the defer statement keeps the function
    //    from running until later
    defer func() {
        // 5.  function runs either when panic happens, or
        //     at the time of a normal function return.
        recover()  // this stops panic mode
        // 6.  statements executed in either case, just
        //     before function returns
    }()
    // 3. more statements executed in either case
    // 4. an expression that may or may not panic
    // 4a.  conditional code. executed only if no panic happens
    return // 7. function return happens in either case
}()
