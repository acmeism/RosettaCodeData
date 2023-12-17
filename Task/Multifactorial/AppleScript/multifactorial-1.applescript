on multifactorial(n, d)
    set f to 1
    repeat with n from n to 2 by -d
        set f to f * n
    end repeat
    return f
end multifactorial

on task()
    set table to ""
    repeat with degree from 1 to 5
        set row to linefeed & "Degree " & degree & ":"
        repeat with n from 1 to 10
            set row to row & (space & multifactorial(n, degree))
        end repeat
        set table to table & row
    end repeat
    return table
end task

task()
