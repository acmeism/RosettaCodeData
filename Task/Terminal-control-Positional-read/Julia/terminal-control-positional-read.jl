using LibNCurses

randtxt(n) = foldl(*, rand(split("1234567890abcdefghijklmnopqrstuvwxyz", ""), n))

initscr()

for i in 1:20
    LibNCurses.mvwaddstr(i, 1, randtxt(50))
end

row = rand(1:20)
col = rand(1:50)
ch = LibNCurses.winch(row, col)
LibNCurses.mvwaddstr(col, 52, "The character at ($row, $col) is $ch.") )
