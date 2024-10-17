println("Playing Penney's Game Against the computer.")

if randbool()
    mach = autobet()
    println(@sprintf "The computer bet first, chosing %s." pgdecode(mach))
    println("Now you can bet.")
    human = pgencode(humanbet())
else
    println("You bet first.")
    human = pgencode(humanbet())
    mach = autobet(human)
end
print(@sprintf "You bet %s " pgdecode(human))
println(@sprintf "and the computer bet %s." pgdecode(mach))
