(load "@lib/simul.l")

(setq *Target (chop "METHINKS IT IS LIKE A WEASEL"))

# Generate random character
(de randChar ()
   (if (=0 (rand 0 26))
      " "
      (char (rand `(char "A") `(char "Z"))) ) )

# Fitness function (Hamming distance)
(de fitness (A)
   (cnt = A *Target) )

# Genetic algorithm
(gen
   (make                               # Parent population
      (do 100                             # C = 100 children
         (link
            (make
               (do (length *Target)
                  (link (randChar)) ) ) ) ) )
   '((A)                               # Termination condition
      (prinl (maxi fitness A))            # Print the fittest element
      (member *Target A) )                # and check if solution is found
   '((A B)                             # Recombination function
      (mapcar
         '((C D) (if (rand T) C D))       # Pick one of the chars
         A B ) )
   '((A)                               # Mutation function
      (mapcar
         '((C)
            (if (=0 (rand 0 10))          # With a proability of 10%
               (randChar)                 # generate a new char, otherwise
               C ) )                      # return the current char
         A ) )
   fitness )                           # Selection function
