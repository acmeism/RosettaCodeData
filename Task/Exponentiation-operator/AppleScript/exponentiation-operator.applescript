on exponentiationOperatorTask(n, power)
    set power to power as integer
    set operatorResult to (n ^ power)
    set handlerResult to exponentiate(n, power)

    return {operator:operatorResult, |handler|:handlerResult}
end exponentiationOperatorTask

on exponentiate(n, power)
    -- AppleScript's ^ operator returns a real (ie. float) result. This handler does the same.
    set n to n as real
    set out to 1.0
    if (power < 0) then
        repeat -power times
            set out to out / n
        end repeat
    else
        repeat power times
            set out to out * n
        end repeat
    end if

    return out
end exponentiate

exponentiationOperatorTask(3, 3) --> {operator:27.0, |handler|:27.0}
exponentiationOperatorTask(2, 16) --> {operator:6.5536E+4, |handler|:6.5536E+4}
exponentiationOperatorTask(2.5, 10) --> {operator:9536.7431640625, |handler|:9536.7431640625}
exponentiationOperatorTask(2.5, -10) --> {operator:1.048576E-4, |handler|:1.048576E-4}
