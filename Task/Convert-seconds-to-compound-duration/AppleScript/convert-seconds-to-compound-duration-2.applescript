on secondsToCompoundDuration(sec)
    if ((sec's class is not integer) or (sec < 0)) then ¬
        error "secondsToCompoundDuration() handler only accepts positive integers."
    -- The task description notwithstanding, return "0 sec" if the input is 0.
    if (sec = 0) then return "0 sec"
    -- Otherwise perform the described task.
    set units to {weeks, days, hours, minutes, 1}
    set suffixes to {" wk, ", " d, ", " hr, ", " min, ", " sec, "}
    set output to ""

    repeat with i from 1 to 5
        set unit to units's item i
        set unitValue to sec div unit
        if (unitValue > 0) then set output to output & unitValue & suffixes's item i
        set sec to sec mod unit
        if (sec = 0) then exit repeat
    end repeat

    return output's text 1 thru -3
end secondsToCompoundDuration

return secondsToCompoundDuration(7259) & linefeed & ¬
    secondsToCompoundDuration(86400) & linefeed & ¬
    secondsToCompoundDuration(6000000)
