(let Envs
   (mapcar
      '((N) (list (cons 'N N) (cons 'Cnt 0)))  # Build environments
      (range 1 12) )
   (while (find '((E) (job E (> N 1))) Envs)   # Until all values are 1:
      (for E Envs
         (job E                                # Use environment 'E'
            (prin (align 4 N))
            (unless (= 1 N)
               (inc 'Cnt)                      # Increment step count
               (setq N
                  (if (bit? 1 N)               # Calculate next hailstone value
                     (inc (* N 3))
                     (/ N 2) ) ) ) ) )
      (prinl) )
   (prinl (need 48 '=))
   (for E Envs                                 # For each environment 'E'
      (job E
         (prin (align 4 Cnt)) ) )              # print the step count
   (prinl) )
