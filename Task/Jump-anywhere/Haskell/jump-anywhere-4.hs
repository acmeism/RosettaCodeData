gcdProg = runProgram $ callCC $ \exit ->          -- <--------+
  do                                              --          |
    start <- label                                -- <-----+  |
    output "Enter two integers, or zero to exit"  --       |  |
    nr <- readInt                                 --       |  |
    n <- get nr                                   --       |  |
    when (n == 0) $                               --       |  |
      do output "Exiting"                         --       |  |
         exit ()                                  -- ---------+
    mr <- readInt                                 --       |
    loop <- label                                 -- <--+  |
    n <- get nr                                   --    |  |
    m <- get mr                                   --    |  |
    when (n == m) $                               --    |  |
      do output ("GCD: " ++ show n)               --    |  |
         goto start                               -- ------+
    when (n > m) $ set nr (n - m)                 --    |
    when (m > n) $ set mr (m - n)                 --    |
    goto loop                                     -- ---+
