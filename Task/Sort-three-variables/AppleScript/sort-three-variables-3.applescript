set x to "lions, tigers, and"
set y to "bears, oh my!"
set z to "(from the \"Wizard of OZ\")"

tell x
    if (it > y) then
        set x to y
        set y to it
    end if
end tell
tell z
    if (it < y) then
        set z to y
        if (it < x) then
            set y to x
            set x to it
        else
            set y to it
        end if
    end if
end tell

return {x, y, z}
