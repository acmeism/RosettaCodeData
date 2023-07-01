(load "@lib/math.l")

(class +Active)
# inp val sum usec

(dm T ()
   (unless (assoc -100 *Run)           # Install timer task
      (task -100 100                   # Update objects every 0.1 sec
         (mapc 'update> *Actives) ) )
   (=: inp '((U) 0))                   # Set zero input function
   (=: val 0)                          # Initialize last value
   (=: sum 0)                          # Initialize sum
   (=: usec (usec))                    # and time
   (push '*Actives This) )             # Install in notification list

(dm input> (Fun)
   (=: inp Fun) )

(dm update> ()
   (let (U (usec)  V ((: inp) U))      # Get current time, calculate value
      (inc (:: sum)
         (*/
            (+ V (: val))              # (K(t[1]) + K(t[0])) *
            (- U (: usec))             # (t[1] - t[0]) /
            2.0 ) )                    # 2.0
      (=: val V)
      (=: usec U) ) )

(dm output> ()
   (format (: sum) *Scl) )             # Get result

(dm stop> ()
   (unless (del This '*Actives)        # Removing the last active object?
      (task -100) ) )                  # Yes: Uninstall timer task

(de integrate ()                       # Test it
   (let Obj (new '(+Active))           # Create an active object
      (input> Obj                      # Set input function
         '((U) (sin (*/ pi U 1.0))) )  # to sin(π * t)
      (wait 2000)                      # Wait 2 sec
      (input> Obj '((U) 0))            # Reset input function
      (wait 500)                       # Wait 0.5 sec
      (prinl "Output: " (output> Obj)) # Print return value
      (stop> Obj) ) )                  # Stop active object
