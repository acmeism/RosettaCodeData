-- WRITER MONAD FOR APPLESCRIPT

-- How can we compose functions which take simple values as arguments
-- but return an output value which is paired with a log string ?

-- We can prevent functions which expect simple values from choking
-- on log-wrapped output (from nested functions)
-- by writing Unit/Return() and Bind() for the Writer monad in AppleScript

on run {}

    -- Derive logging versions of three simple functions, pairing
    -- each function with a particular comment string

    -- (a -> b) -> (a -> (b, String))
    set wRoot to writerVersion(root, "obtained square root")
    set wSucc to writerVersion(succ, "added one")
    set wHalf to writerVersion(half, "divided by two")

    loggingHalfOfRootPlusOne(5)

    --> value + log string
end run


-- THREE SIMPLE FUNCTIONS
on root(x)
    x ^ (1 / 2)
end root

on succ(x)
    x + 1
end succ

on half(x)
    x / 2
end half

-- DERIVE A LOGGING VERSION OF A FUNCTION  BY COMBINING IT WITH A
-- LOG STRING FOR THAT FUNCTION
-- (SEE 'on run()' handler at top of script)
-- (a -> b) -> String -> (a -> (b, String))
on writerVersion(f, strComment)
    script
        on call(x)
            {value:sReturn(f)'s call(x), comment:strComment}
        end call
    end script
end writerVersion


-- DEFINE A COMPOSITION OF THE SAFE VERSIONS
on loggingHalfOfRootPlusOne(x)
    logCompose([my wHalf, my wSucc, my wRoot], x)
end loggingHalfOfRootPlusOne


-- Monadic UNIT/RETURN and BIND functions for the writer monad
on writerUnit(a)
    try
        set strValue to ": " & a as string
    on error
        set strValue to ""
    end try
    {value:a, comment:"Initial value" & strValue}
end writerUnit

on writerBind(recWriter, wf)
    set recB to wf's call(value of recWriter)
    set v to value of recB

    try
        set strV to " -> " & (v as string)
    on error
        set strV to ""
    end try

    {value:v, comment:(comment of recWriter) & linefeed & (comment of recB) & strV}
end writerBind

-- THE TWO HIGHER ORDER FUNCTIONS ABOVE ENABLE COMPOSITION OF
-- THE LOGGING VERSIONS OF EACH FUNCTION
on logCompose(lstFunctions, varValue)
    reduceRight(lstFunctions, writerBind, writerUnit(varValue))
end logCompose

-- xs: list, f: function, a: initial accumulator value
-- the arguments available to the function f(a, x, i, l) are
-- v: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional
on reduceRight(xs, f, a)
    set sf to sReturn(f)

    repeat with i from length of xs to 1 by -1
        set a to sf's call(a, item i of xs, i, xs)
    end repeat
end reduceRight

-- Unit/Return and bind for composing handlers in script wrappers
-- lift 2nd class function into 1st class wrapper
-- handler function --> first class script object
on sReturn(f)
    script
        property call : f
    end script
end sReturn

-- return a new script in which function g is composed
-- with the f (call()) of the Mf script
-- Mf -> (f -> Mg) -> Mg
on sBind(mf, g)
    script
        on call(x)
            sReturn(g)'s call(mf's call(x))
        end call
    end script
end sBind
