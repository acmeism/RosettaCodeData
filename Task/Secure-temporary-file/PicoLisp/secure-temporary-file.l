: (out (tmp "foo") (println 123))         # Write tempfile
-> 123

: (in (tmp "foo") (read))                 # Read tempfile
-> 123

: (let F (tmp "foo")
   (ctl F                                 # Get exclusive lock
      (let N (in F (read))                # Atomic increment
         (out F (println (inc N))) ) ) )
-> 124
