global forks, names

procedure main(A)
    names := ["Aristotle","Kant","Spinoza","Marks","Russell"]
    write("^C to terminate")
    nP := *names
    forks := [: |mutex([])\nP :]
    every p := !nP do thread philosopher(p)
    delay(-1)
end

procedure philosopher(n)
    f1 := forks[min(n, n%*forks+1)]
    f2 := forks[max(n, n%*forks+1)]
    repeat {
        write(names[n]," thinking")
        delay(1000*?5)
        write(names[n]," hungry")
        repeat {
            fork1 := lock(f1)
            if fork2 := trylock(f2) then {
                write(names[n]," eating")
                delay(1000*?5)
                break (unlock(fork2), unlock(fork1))  # full
                }
            unlock(fork1)  # Free first fork and go back to waiting
            }
        }
end
