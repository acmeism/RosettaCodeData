on run
    if ((path to me) = (path to current application)) then
        display dialog "I'm running in my own application."
    else
        display dialog "I'm being run from another script or application."
    end if
end run
