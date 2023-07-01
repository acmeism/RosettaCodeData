set x to "lions, tigers, and"
set y to "bears, oh my!"
set z to "(from the \"Wizard of OZ\")"

if (x > y) then set {x, y} to {y, x}
if (y > z) then
    set {y, z} to {z, y}
    if (x > y) then set {x, y} to {y, x}
end if

return {x, y, z}
