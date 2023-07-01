procedure main(A)
    n := integer(A[1] | 3)    # Max. number of active tasks
    m := integer(A[2] | 2)    # Number of visits by each task
    k := integer(A[3] | 5)    # Number of tasks
    sem := [: |mutex([])\n :]
    every put(threads := [], (i := 1 to k, thread
              every 1 to m do {
                 write("unit ",i," ready")
                 until flag := trylock(!sem)
                 write("unit ",i," running")
                 delay(2000)
                 write("unit ",i," done")
                 unlock(flag)
                 }))

    every wait(!threads)
end
