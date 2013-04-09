(let N 41
   (unless (= N 42) (! setq N 42)) )   # '!' is a breakpoint
(setq N 42)                            # Manually fix the value
!                                      # Hit ENTER to leave the breakpoint
-> 42
