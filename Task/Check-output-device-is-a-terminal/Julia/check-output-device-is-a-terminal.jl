if isa(STDOUT, Base.TTY)
    println("This program sees STDOUT as a TTY.")
else
    println("This program does not see STDOUT as a TTY.")
end
