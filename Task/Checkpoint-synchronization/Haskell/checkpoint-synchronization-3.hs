global nWorkers, workers, cv

procedure main(A)
    nWorkers := integer(A[1]) | 3
    cv  := condvar()
    every put(workers := [], worker(!nWorkers))
    every wait(!workers)
end

procedure worker(n)
    return thread every !3 do {       # Union limits each worker to 3 pieces
        write(n," is working")
        delay(?3 * 1000)
        write(n," is done")
        countdown()
        }
end

procedure countdown()
    critical cv: {
        if (nWorkers -:= 1) <= 0 then {
            write("\t\tAll done")
            nWorkers := *workers
            return (unlock(cv),signal(cv, 0))
            }
        wait(cv)
        }
end
