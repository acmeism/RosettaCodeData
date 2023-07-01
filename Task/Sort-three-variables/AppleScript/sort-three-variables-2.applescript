set x to 77444
set y to -12
set z to 0

if (x > y) then set {x, y} to {y, x}
if (y > z) then
    set {y, z} to {z, y}
    if (x > y) then set {x, y} to {y, x}
end if

return {x, y, z}
