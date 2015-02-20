sequence first, second
integer x

first = "qwertyuiop"

-- Determining if the first string starts with second string
second = "qwerty"
if match(second, first) = 1 then
    printf(1, "'%s' starts with '%s'\n", {first, second})
else
    printf(1, "'%s' does not start with '%s'\n", {first, second})
end if

-- Determining if the first string contains the second string at any location
-- Print the location of the match for part 2
second = "wert"
x = match(second, first)
if x then
    printf(1, "'%s' contains '%s' at position %d\n", {first, second, x})
else
    printf(1, "'%s' does not contain '%s'\n", {first, second})
end if

-- Determining if the first string ends with the second string
second = "uio"
if length(second)<=length(first) and match_from(second, first, length(first)-length(second)+1) then
    printf(1, "'%s' ends with '%s'\n", {first, second})
else
    printf(1, "'%s' does not end with '%s'\n", {first, second})
end if
