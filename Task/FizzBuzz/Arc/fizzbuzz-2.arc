(for n 1 100
     (prn:check (string (when (multiple n 3) 'Fizz)
                        (when (multiple n 5) 'Buzz))
                ~empty n)) ; check created string not empty, else return n
