: (out (tmp "foo") (println 123))         # Write tempfile
-> 123

: (in (tmp "foo") (read))                 # Read tempfile
-> 123

: (let F (tmp "foo")
   (ctl F                                 # Get exclusive lock
      (in F
         (let N (read)                    # Atomic increment
            (out F (println (inc N))) ) ) ) )
-> 124
