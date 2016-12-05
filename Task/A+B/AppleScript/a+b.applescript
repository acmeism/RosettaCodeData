on run argv
    try
        return ((first item of argv) as integer) + (second item of argv) as integer
    on error
        return "Usage with -1000 <= a,b <= 1000: " & tab & " A+B.scpt a b"
    end try
end run
