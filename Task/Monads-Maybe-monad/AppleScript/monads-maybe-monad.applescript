property e : 2.71828182846

on run {}

    -- Derive safe versions of three simple functions
    set sfReciprocal to safeVersion(reciprocal, notZero)
    set sfRoot to safeVersion(root, isPositive)
    set sfLog to safeVersion(ln, aboveZero)


    -- Test a composition of these function with a range of invalid and valid arguments

    -- (The safe composition returns missing value (without error) for invalid arguments)

    map([-2, -1, -0.5, 0, 1 / e, 1, 2, e, 3, 4, 5], safeLogRootReciprocal)

    -- 'missing value' is returned by a safe function (and threaded up through the monad) when the input argument is out of range
    --> {missing value, missing value, missing value, missing value, 0.5, 0.0, -0.346573590279, -0.499999999999, -0.549306144333, -0.69314718056, -0.804718956217}
end run


-- START WITH SOME SIMPLE (UNSAFE) PARTIAL FUNCTIONS:

-- Returns ERROR 'Script Error: Can’t divide 1.0 by zero.' if n = 0
on reciprocal(n)
    1 / n
end reciprocal

-- Returns ERROR 'error "The result of a numeric operation was too large." number -2702'
-- for all values below 0
on root(n)
    n ^ (1 / 2)
end root

-- Returns -1.0E+20 for all values of zero and below
on ln(n)
    (do shell script ("echo 'l(" & (n as string) & ")' | bc -l")) as real
end ln

-- DERIVE A SAFE VERSION OF EACH FUNCTION
-- (SEE on Run() handler)

on safeVersion(f, fnSafetyCheck)
    script
        on call(x)
            if sReturn(fnSafetyCheck)'s call(x) then
                sReturn(f)'s call(x)
            else
                missing value
            end if
        end call
    end script
end safeVersion

on notZero(n)
    n is not 0
end notZero

on isPositive(n)
    n ≥ 0
end isPositive

on aboveZero(n)
    n > 0
end aboveZero


-- DEFINE A FUNCTION WHICH CALLS A COMPOSITION OF THE SAFE VERSIONS
on safeLogRootReciprocal(x)

    value of mbCompose([my sfLog, my sfRoot, my sfReciprocal], x)

end safeLogRootReciprocal


-- UNIT/RETURN and BIND functions for the Maybe monad

-- Unit / Return for maybe
on maybe(n)
    {isValid:n is not missing value, value:n}
end maybe

-- BIND maybe
on mbBind(recMaybe, mfSafe)
    if isValid of recMaybe then
        maybe(mfSafe's call(value of recMaybe))
    else
        recMaybe
    end if
end mbBind

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

on mbCompose(lstFunctions, value)
    reduceRight(lstFunctions, mbBind, maybe(value))
end mbCompose

-- xs: list, f: function, a: initial accumulator value
-- the arguments available to the function f(a, x, i, l) are
-- v: current accumulator value
-- x: current item in list
-- i: [ 1-based index in list ] optional
-- l: [ a reference to the list itself ] optional
on reduceRight(xs, f, a)
    set mf to sReturn(f)

    repeat with i from length of xs to 1 by -1
        set a to mf's call(a, item i of xs, i, xs)
    end repeat
end reduceRight

-- [a] -> (a -> b) -> [b]
on map(xs, f)
    set mf to sReturn(f)
    set lst to {}
    set lng to length of xs
    repeat with i from 1 to lng
        set end of lst to mf's call(item i of xs, i, xs)
    end repeat
    return lst
end map
