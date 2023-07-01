    outer-loop: loop {
        inner-loop: loop {
            # NYI # goto inner-loop if rand > 0.5; # Hard goto
            next inner-loop if rand > 0.5; # Next loop iteration
            redo inner-loop if rand > 0.5; # Re-execute block
            last outer-loop if rand > 0.5; # Exit the loop
            ENTER { say "Entered inner loop block" }
            LEAVE { say "Leaving inner loop block" }
        }
        ENTER { say "Entered outer loop block" }
        LEAVE { say "Leaving outer loop block" }
        LAST  { say "Ending outer loop" }
    }
