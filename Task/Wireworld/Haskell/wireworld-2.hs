oscillator= [" tH    ",
             ".  ....",
             " ..    "
            ]

example = mapM_ (mapM_ putStrLn) .map (borden ' ').take 9 $ runCircuit oscillator
